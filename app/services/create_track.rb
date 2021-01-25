class CreateTrack
  def initialize(station:)
    @station = station
  end

  def call
    ActiveSupport::Notifications.instrument(:station_fetch, event_name: :fetch_station) do |payload|
      payload[:station] = station
      payload[:playlist_url] = station.playlist_url
      payload[:strategy] = station.strategy.camelize
      @response = scraper.call
      payload[:state] = :no_data
      payload[:respose] = scraper.fetched_data

      track = nil
      if @response
        if ignored?
          payload[:reason] = "ignored track"
        elsif last_track?
          payload[:reason] = "was last track"
        else
          payload[:state] = :ok
          track = create_entry(@response)
          payload[:track] = track
        end
      end
      track
    end
  end

  private
    attr_reader :station

    def slug
      return unless @response

      @slug ||= build_track_slug @response
    end

    def last_track?
      station.tracks.last&.slug == slug
    end

    def ignored?
      TrackInfo.where(slug: slug).where(ignored: true).any?
    end

    def scraper
      @scraper ||= "::Strategy::#{station.strategy.camelize}".constantize.new(
        url: station.playlist_url
      )
    end

    def create_entry(response)
      ActiveRecord::Base.transaction do
        station.touch(:last_logged_at)
        Track.create! do |entry|
          entry.station = station
          entry.artist = response.artist
          entry.title = response.title
          entry.response = response.response
          entry.slug = slug
          entry.played_at = response.played_at
        end
      end
    end

    def build_track_slug(response)
      SlugBuilder.new(artist: response.artist, title: response.title).call
    end
end

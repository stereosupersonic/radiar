class CreateTrack
  def initialize(station:)
    @station = station
  end

  def call
    ActiveSupport::Notifications.instrument(:station_fetch, event_name: :fetch_station) do |payload|
      payload[:station] = station
      payload[:playlist_url] = station.playlist_url
      payload[:strategy] = station.strategy.camelize
      response = scraper.call
      payload[:state] = :no_data
      payload[:respose] = scraper.fetched_data

      if response

        payload[:state] = :ok
        track = create_entry(response)
        payload[:track] = track
        track
      end
    end
  end

  private

  attr_reader :station

  def scraper
    @scraper ||= "::Strategy::#{station.strategy.camelize}".constantize.new(
      url: station.playlist_url
    )
  end

  def create_entry(response)
    slug = build_track_slug response

    return if station.tracks.last&.slug == slug

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
    "#{response.artist}#{response.title}".gsub(/[^\w|:]/, "").gsub(/(\+|-|_|\.)/, "").to_s.downcase
  end
end

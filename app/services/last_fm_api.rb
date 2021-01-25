require "open-uri"
# LastFmApi.new(artist: "Liam Gallagher", title: "Once").call

class LastFmApi
  BASE_URL = "http://ws.audioscrobbler.com/2.0/".freeze

  def initialize(track:)
    @artist = track.artist
    @title = track.title
    @track = track
  end

  # http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=03a888a88c3abea4963563b3f736862c&artist=cher&track=believe&format=json
  def call
    fetch_data
    result
  end

  private
    attr_reader :track, :artist, :title

    def album
      @response.dig("album", "title").presence
    end

    def tags
      Array(@response.dig("toptags", "tag")).map { |v| v["name"].to_s.downcase }.reject(&:blank?)
    end

    def result
      @result ||= OpenStruct.new(
        album: TrackSanitizer.new(text: album.presence).call,
        tags: tags
      )
    end

    def url
      @url ||= "#{BASE_URL}?#{params.to_query}"
    end

    def no_data?
      album.blank? && tags&.empty?
    end

    def fetch_data
      ActiveSupport::Notifications.instrument(:log_api_request, event_name: :last_fm_api) do |payload|
        raw_response = URI.open(url) { |f|
          payload[:base_uri] = f.base_uri.to_s
          payload[:status_code] = f.status.first.to_i
          payload[:status] = f.status.last
          payload[:metas] = f.metas
          payload[:track] = track

          f.read
        }
        @response = JSON.parse(raw_response)["track"] || {}

        payload[:data] = result.to_h.merge track_info: track&.track_info&.id, artist: artist, title: title
        payload[:status] = :no_data if no_data?
        @response
      end
    end

    def params
      {
        method: "track.getInfo",
        api_key: ENV["LASTFM_API_KEY"],
        artist: @artist,
        track: @title,
        autocorrect: 1,
        format: :json
      }
    end
end

require "open-uri"
# LastFmApi.new(artist: "Liam Gallagher", title: "Once").call

class LastFmApi
  BASE_URL = "http://ws.audioscrobbler.com/2.0/".freeze

  def initialize(artist:, title:)
    @artist = artist
    @title = title
  end

  # http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=03a888a88c3abea4963563b3f736862c&artist=cher&track=believe&format=json
  def call
    fetch_data
    result
  end

  def url
    @url ||= "#{BASE_URL}?#{params.to_query}"
  end

  private
    attr_reader :artist, :title

    def album
      @response.dig("album", "title").presence
    end

    def tags
      Array(@response.dig("toptags", "tag")).map { |v| v["name"].to_s.downcase }.reject(&:blank?)
    end

    def result
      return if  data.to_h.values.compact.blank?
      data
    end

    def data
      @data ||= OpenStruct.new(
        album: TrackSanitizer.new(text: album.presence).call,
        tags: tags
      )
    end

    def fetch_data
      raw_response = URI.open(url) { |f| f.read }
      @response = JSON.parse(raw_response)["track"] || {}
      @response
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

require "uri"
require "net/http"
require "openssl"

# MusicGraphApi.new(artist: "Liam Gallagher", title: "Once").call

# {"songName"=>"Once",
# "albumTitle"=>"Once",
# "thumbnails"=>
# {"high-quality"=>"https://img.youtube.com/vi/MDhiQfekdxo/hqdefault.jpg",
#  "standard"=>"https://img.youtube.com/vi/MDhiQfekdxo/sddefault.jpg"},
# "featuredArtists"=>"",
# "genre"=>["Alternative/indie", "Rock"],
# "releaseDate"=>"2019",
# "artist"=>"Liam Gallagher",
# "ytVideo"=>"MDhiQfekdxo"}

class MusicGraphApi
  BASE_URL = "https://macgyverapi-music-graph-v1.p.rapidapi.com/"

  def initialize(artist:, title:, track:)
    @artist = artist
    @title = title
    @track = track
  end

  def call
    fetch_data
    result
  end

  private

  attr_reader :artist, :title, :track

  def result
    @result ||= OpenStruct.new(
      album: TrackSanitizer.new(text: album.presence).call,
      year: year,
      youtube_id: youtube_id,
      pic_url: pic_url
    )
  end

  def album
    api_data["albumTitle"].presence
  end

  def year
    api_data["releaseDate"].to_s[/\d{4}/].presence
  end

  def youtube_id
    api_data["ytVideo"].presence
  end

  def pic_url
    (api_data["thumbnails"] || {}).values.first
  end

  def api_data
    @api_data ||= @fetched_data["result"]&.first || {}
  end

  def no_data?
    year.blank? && album.blank? && youtube_id.blank?
  end

  def fetch_data
    ActiveSupport::Notifications.instrument(:log_api_request, event_name: :musci_graph_api) do |payload|
      url = URI(BASE_URL)
      @fetched_data = {}
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request["x-rapidapi-host"] = "macgyverapi-music-graph-v1.p.rapidapi.com"
      request["x-rapidapi-key"] = ENV["MUSIC_GRAPH_API_KEY"]
      request["content-type"] = "application/json"
      request["accept"] = "application/json"
      data = {key: :free, id: "9m9c8U4f", data: {search: "#{title} #{artist}"}}
      request.body = data.to_json

      payload[:base_uri] = url.to_s
      payload[:metas] = {request: request.to_hash}
      payload[:track] = track
      response = http.request(request)
      payload[:status_code] = response.code
      if response.code != "200"
        Rails.logger.error "MusicAPI Error - code:#{response.code} message:#{response.message}"
        payload[:status] = :no_data
        return @fetched_data
      end
      raw_response = response.read_body

      @fetched_data = JSON.parse raw_response
      payload[:data] = result.to_h.merge track_info: track&.track_info&.id, artist: artist, title: title
      payload[:status] = no_data? ? :no_data : :ok
      @fetched_data
    end
  end
end

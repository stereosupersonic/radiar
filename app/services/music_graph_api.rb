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

  def initialize(artist:, title:)
    @artist = artist
    @title = title
  end

  def call
    result = fetch_data
    result["result"]&.first || {}
  end

  private

  def fetch_data
    url = URI(BASE_URL)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["x-rapidapi-host"] = "macgyverapi-music-graph-v1.p.rapidapi.com"
    request["x-rapidapi-key"] = ENV["MUSIC_GRAPH_API_KEY"]
    request["content-type"] = "application/json"
    request["accept"] = "application/json"
    data = {key: :free, id: "9m9c8U4f", data: {search: "#{@title} #{@artist}"}}
    request.body = data.to_json

    response = http.request(request)

    if response.code != "200"
      raise "MusicAPI Error - code:#{response.code} message:#{response.message}"
    end
    raw_response = response.read_body

    JSON.parse raw_response
  end
end

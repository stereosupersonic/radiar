
    require 'uri'
    require 'net/http'
    require 'openssl'
    require 'JSON'
# MusicGraph.new(artist: "Liam Gallagher", track: "Once").test

class MusicGraph
  API_KEY="d3e8ad5042msh806ad2352831e18p1034a1jsn014800176cba"
  BASE_URL = "https://macgyverapi-music-graph-v1.p.rapidapi.com/"

  def initialize(artist:, track:)
    @artist = artist
    @track  = track
  end

  def call
    # url https://rapidapi.com/macgyverapi/api/music-graph
  
    result = fetch
    # debug puts result["result"]
    result["result"]&.first || {}
  end

  def test
    info = call
    puts "---- MUSIC GRAPH ------"
    puts "Song: " + info["songName"]
    puts "Artist: " + info["artist"]
    puts "Album: " +info["albumTitle"]
    puts "Release: " + info["releaseDate"]
  end

  private

  def fetch
    url = URI(BASE_URL)
 
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Post.new(url)
    request["x-rapidapi-host"] = 'macgyverapi-music-graph-v1.p.rapidapi.com'
    request["x-rapidapi-key"] = API_KEY
    request["content-type"] = 'application/json'
    request["accept"] = 'application/json'
    
    
    request.body = "{    \"key\": \"free\",    \"id\": \"9m9c8U4f\",    \"data\": {        \"search\": \"#{@track } #{@artist} \"    }}"
    
    response = http.request(request)
    JSON.parse response.read_body
  end

end

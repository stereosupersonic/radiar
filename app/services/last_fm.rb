require "open-uri"
# LastFm.new(artist: "Liam Gallagher", track: "Once").call

class LastFm
  API_KEY = "03a888a88c3abea4963563b3f736862c"
  BASE_URL = "http://ws.audioscrobbler.com/2.0/"
  def initialize(artist:, track:)
    @artist = artist
    @track = track
  end

  # http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=03a888a88c3abea4963563b3f736862c&artist=cher&track=believe&format=json
  def call
    url = "#{BASE_URL}?#{params.to_query}"

    raw_response = URI.open(url).read
    response = JSON.parse raw_response

    response["track"]
  end

  def test
    # track_info = call
    # puts "---- LAST FM ----"
    #  puts "Song: #{track_info["name"]}"
    #  puts "Artist: #{track_info["artist"]["name"]}"
    #  puts "Album: #{track_info["album"]["title"]}"
    #  puts "Release: #{release_date track_info["mbid"]}"
    #  puts "Tags: " + track_info["toptags"]["tag"].map { |v| v["name"] }.join(";")
  end

  private

  def params
    {
      method: "track.getInfo",
      api_key: API_KEY,
      artist: @artist,
      track: @track,
      autocorrect: 1,
      format: :json
    }
  end
end

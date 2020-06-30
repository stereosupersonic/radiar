require "open-uri"
# LastFm.new(artist: "Liam Gallagher", title: "Once").call

class LastFm
  BASE_URL = "http://ws.audioscrobbler.com/2.0/"
  def initialize(artist:, title:)
    @artist = artist
    @title = title
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
    #  puts "Tags: " + track_info["toptags"]["tag"].map { |v| v["name"] }.join(";")
  end

  private

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

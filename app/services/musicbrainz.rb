class Musicbrainz
  def initialize(mbid:)
    @mbid = mbid
  end

  def call
    #  mbid = "56d2735d-abc7-4070-9c3f-bc27593d922d"
    url = "https://musicbrainz.org/ws/2/recording/#{@mbid}?inc=releases&fmt=json"

    raw = URI.open(url, "User-Agent" => "curl/7.54.0").read
    response = JSON.parse raw

    response["releases"][0]["date"]
  end
end

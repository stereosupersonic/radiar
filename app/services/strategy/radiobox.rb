require "nokogiri"
require "open-uri"

# url = https://onlineradiobox.com/uk/absolute1058/playlist/
# script .playlist tr.active a
# radio_box = Radiobox.new url: "https://onlineradiobox.com/uk/absolute1058/playlist/", script: ".playlist tr.active a"

# http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=03a888a88c3abea4963563b3f736862c&artist=cher&track=believe&format=json
module Strategy
  class Radiobox
    SELECTOR = ".playlist tr.active a"
    Response = Struct.new(:artist, :title, :response, :played_at)

    def initialize(url:)
      @url = url
    end

    def call
      value = Array(doc.css(SELECTOR))[0]
      track_info = value&.text
      artist, title = *track_info.split(" - ")
      played_at = Time.current # TODO use the real date
      Response.new(normalize(artist), normalize(title), value.to_html, played_at)
    end

    private

    def normalize(text)
      text.to_s.strip.titleize
    end

    def fetch_html
      URI.open @url
    end

    def doc
      @doc ||= ::Nokogiri::HTML(fetch_html)
    end
  end
end

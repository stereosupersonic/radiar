require "nokogiri"
require "open-uri"

# url = https://onlineradiobox.com/uk/absolute1058/playlist/
# script .playlist tr.active a
# radio_box = Radiobox.new url: "https://onlineradiobox.com/uk/absolute1058/playlist/", script: ".playlist tr.active a"

# http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=03a888a88c3abea4963563b3f736862c&artist=cher&track=believe&format=json
module Strategy
  class Radiobox
    SELECTOR = ".playlist .tablelist-schedule tr:first td[2]".freeze
    Response = Struct.new(:artist, :title, :response, :played_at)

    def initialize(url:)
      @url = url
    end

    def call
      value = Array(doc.css(SELECTOR))[0]
      track_info = value&.text

      if track_info.blank?
        Rails.logger.error "no track for selector '#{SELECTOR}' url: #{@url}"
        return
      end

      response = TrackExtractor.new(text: track_info).call

      played_at = Time.current # TODO: use the real date
      Response.new(response.artist, response.title, value.to_html, played_at)
    end

    private

    def fetch_html
      URI.open @url
    end

    def doc
      @doc ||= ::Nokogiri::HTML(fetch_html)
    end
  end
end

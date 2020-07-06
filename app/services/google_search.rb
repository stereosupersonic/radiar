require "open-uri"
require "ostruct"

# GoogleSearch.new(artist: "Liam Gallagher", title: "Once").call
class GoogleSearch
  USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0"

  BASE_URL = "https://www.google.com/search"

  def initialize(artist:, title:, track_info: nil)
    @artist = artist
    @title = title
    @track_info = track_info
  end

  def call
    result
  end

  private

  attr_reader :track_info, :artist, :title

  def result
    OpenStruct.new year: year.presence, album: album.presence, tags: tags.presence
  end

  def year
    doc.css('div[data-attrid="kc:/music/recording_cluster:release date"] span:last').text
  end

  def album
    doc.css('div[data-attrid="kc:/music/recording_cluster:first album"] span:last').text
  end

  def tags
    raw = doc.css('div[data-attrid="kc:/music/recording_cluster:skos_genre"] span:last').text
    raw.to_s.split(",").map(&:squish)
  end

  def url
    "#{BASE_URL}?#{params.to_query}"
  end

  def fetch_html
    ActiveSupport::Notifications.instrument(:log_api_request, event_name: :google_search) do |instrument|
      response = URI.open(url, "User-Agent" => USER_AGENT) { |f|
        instrument[:base_uri] = f.base_uri.to_s
        instrument[:status] = f.status.last
        instrument[:status_code] = f.status.first.to_i
        instrument[:metas] = f.metas
        f.read
      }
      @doc = ::Nokogiri::HTML(response)
      instrument[:data] = result.to_h.merge track_info: track_info&.id, artist: artist, title: title
      @doc
    end
  end

  def params
    {
      q: "'#{@artist}' '#{@title}'"
    }
  end

  def doc
    @doc ||= fetch_html
  end
end

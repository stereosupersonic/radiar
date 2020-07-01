require "open-uri"
require "ostruct"

# GoogleSearch.new(artist: "Liam Gallagher", title: "Once").call
class GoogleSearch
  USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0"

  BASE_URL = "https://www.google.com/search"

  def initialize(artist:, title:)
    @artist = artist
    @title = title
  end

  def call
    return if year.blank?
    OpenStruct.new year: year.presence, album: album.presence, tags: tags.presence
  end

  private

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
    URI.open(url, "User-Agent" => USER_AGENT).read
  end

  def params
    {
      q: "'#{@artist}' '#{@title}'"
    }
  end

  def doc
    @doc ||= ::Nokogiri::HTML(fetch_html)
  end
end

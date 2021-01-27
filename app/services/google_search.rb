require "open-uri"
require "ostruct"

# GoogleSearch.new(artist: "Liam Gallagher", title: "Once").call
class GoogleSearch
  USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0".freeze

  BASE_URL = "https://www.google.com/search".freeze

  def initialize(artist:, title:)
    @artist = artist
    @title = title
  end

  def call
    retrun unless doc
    result
  end

  def url
    "#{BASE_URL}?#{params.to_query}"
  end

  private
    attr_reader :artist, :title

    def result
      return if data.to_h.values.compact.blank?
      data
    end

    def data
      @result ||= OpenStruct.new(
        youtube_id: youtube_id,
        year: year.presence,
        album: TrackSanitizer.new(text: album.presence).call,
        tags: tags.presence)
    end

    def year
      doc.css('div[data-attrid="kc:/music/recording_cluster:release date"] span:last').text
    end

    def album
      doc.css('div[data-attrid="kc:/music/recording_cluster:first album"] span:last').text
    end

    def tags
      raw = doc.css('div[data-attrid="kc:/music/recording_cluster:skos_genre"] span:last').text
      raw.to_s.split(",").map { |tag| tag.to_s.squish.downcase }
    end

    def youtube_id
      nodeset = doc.css("a")          # Get all anchors via css
      links = nodeset.map { |element| element["href"] }.compact
      link_url = links.select { | link | link =~ /\/www\.youtube\.com\/watch/ }.first
      link_url[/v=(\w+)/, 1] if link_url.present?
    end

    def no_data?
      year.blank? && album.blank? && tags.empty? && youtube_id.blank?
    end

    def params
      {
        q: "'#{@artist}' '#{@title}'"
      }
    end

    def doc
      return @doc if defined?(@doc)

      response = URI.open(url, "User-Agent" => USER_AGENT) { |f| f.read }
      @doc = ::Nokogiri::HTML(response)
      @doc
    end
end

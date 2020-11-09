require "open-uri"
require "ostruct"

# GoogleSearch.new(artist: "Liam Gallagher", title: "Once").call
class GoogleSearch
  USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0".freeze

  BASE_URL = "https://www.google.com/search".freeze

  def initialize(artist:, title:, track:)
    @artist = artist
    @title = title
    @track = track
  end

  def call
    result
  end

  private

  attr_reader :track, :artist, :title

  def result
    @result ||= OpenStruct.new year: year.presence, album: TrackSanitizer.new(text: album.presence).call, tags: tags.presence
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

  def url
    "#{BASE_URL}?#{params.to_query}"
  end

  def no_data?
    year.blank? && album.blank? && tags.empty?
  end

  def fetch_html
    ActiveSupport::Notifications.instrument(:log_api_request, event_name: :google_search) do |payload|
      response = URI.open(url, "User-Agent" => USER_AGENT) { |f|
        payload[:base_uri] = f.base_uri.to_s
        payload[:status_code] = f.status.first.to_i
        payload[:status] = f.status.last
        payload[:metas] = f.metas
        payload[:track] = track

        f.read
      }
      @doc = ::Nokogiri::HTML(response)

      payload[:data] = result.to_h.merge track_info: track&.track_info&.id, artist: artist, title: title
      payload[:status] = :no_data if no_data?
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

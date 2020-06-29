require "nokogiri"
require "open-uri"

# url = https://onlineradiobox.com/uk/absolute1058/playlist/
#script .playlist tr.active a
# radio_box = Radiobox.new url: "https://onlineradiobox.com/uk/absolute1058/playlist/", script: ".playlist tr.active a"

# http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=03a888a88c3abea4963563b3f736862c&artist=cher&track=believe&format=json
class Radiobox
  
  def initialize(url:, script:)
    @url = url
    @script = script
  end

  def call
 #   require 'pry-nav'; binding.pry;
    value = Array(doc.css(@script))[0]
    require 'pry-nav'; binding.pry;
    track_info = value&.text
    #puts doc
    artist, title = *track_info.split(" - ")

    Rails.logger.info "scraped artist:#{artist} title:#{title}"
    Scraper::Track.new(normalize(artist), normalize(title))
  end

  def self.test
    urls = [
      "https://onlineradiobox.com/uk/absolute1058/playlist/",
      "https://onlineradiobox.com/it/marilu/playlist/",
      "https://onlineradiobox.com/uk/planetrock/playlist"
    ]
    urls.each do |url|
      show_data_by_station url
    end
  end

  def self.show_data_by_station(url)
    radio_box = self.new url: url, script: ".playlist tr.active a"
    track = radio_box.call
    puts "############## #{url} ##############"
    puts "date: #{Time.now}"
    puts "search: #{track.title} -  #{track.artist}"
    LastFm.new(artist: track.artist, track: track.title).test
    MusicGraph.new(artist: track.artist, track: track.title).test
    puts ""
  end

  private

  def parse_script(script)
    script.to_s.gsub(%r{<\/?[^>]*>.*<\/?[^>]*>}, "").strip
  end

  def parse_for_regex_script(script)
    script.to_s[%r{<regex>(.*)<\/regex>}, 1]
  end

  def normalize(text)
    text.to_s.strip.titleize
  end

  def fetch_html

    open @url 
  end

  def doc
    @doc ||= ::Nokogiri::HTML(fetch_html)
  end
end

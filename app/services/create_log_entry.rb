require "open-uri"

class CreateLogEntry
  def initialize(station)
    @station = station
  end

  def call
    track = fetch_track # get track from scraper
    create_log_entry(track)
  end

  private

  attr_reader :station

  def fetch_track
    Scraper.new(
      html: fetch_html,
      scraper_type: station.scraper,
      title_script: station.title_script,
      artist_script: station.artist_script
    ).call
  end

  def create_log_entry(track)
    slug = build_track_slug track

    return if station.log_entries.last&.slug == slug

    ActiveRecord::Base.transaction do
      LogEntry.create! do |entry|
        entry.station = station
        entry.artist = track.artist
        entry.title = track.title
        entry.slug = slug
      end
      station.touch(:last_logged_at)
    end
  end

  def build_track_slug(track)
    "#{track.artist}#{track.title}".gsub(/[^\w|\:]/, "").gsub(/(\+|-|_|\.)/, "").to_s.downcase
  end

  def fetch_html
    open(station.url)
  end
end

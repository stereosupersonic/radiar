class CreateTrack
  def initialize(station:)
    @station = station
  end

  def call
    response = scraper.call
    return unless response

    create_entry(response)
  end

  private

  attr_reader :station

  def scraper
    "::Strategy::#{station.strategy.camelize}".constantize.new(
      url: station.playlist_url
    )
  end

  def create_entry(response)
    slug = build_track_slug response

    return if station.tracks.last&.slug == slug

    ActiveRecord::Base.transaction do
      station.touch(:last_logged_at)
      Track.create! do |entry|
        entry.station = station
        entry.artist = response.artist
        entry.title = response.title
        entry.response = response.response
        entry.slug = slug
        entry.played_at = response.played_at
      end
    end
  end

  def build_track_slug(response)
    "#{response.artist}#{response.title}".gsub(/[^\w|:]/, "").gsub(/(\+|-|_|\.)/, "").to_s.downcase
  end
end

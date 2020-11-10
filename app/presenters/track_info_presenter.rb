class TrackInfoPresenter < ApplicationPresenter
  def title
    h.truncate o&.name
  end

  def info
    "#{artist} - #{title}" if o
  end

  def artist
    h.truncate o&.artist_name
  end

  def album
    h.truncate o&.album
  end

  def year
    o&.year
  end

  def tags
    o&.tags
  end

  def youtube_id
    o&.youtube_id
  end

  def main_tag
    h.truncate Array(tags).first&.titleize
  end

  def stations
    @stations ||= o.tracks.pluck(:station_id).uniq.map { |station_id| Admin::StationPresenter.new(Station.find(station_id)) }
  end

  def youtube_url
    "https://www.youtube.com/watch?v=#{youtube_id}" if youtube_id.present?
  end

  def youtube_link
    youtube_url ? h.link_to("youtube", youtube_url) : ""
  end
end

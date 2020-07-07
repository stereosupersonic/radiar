class TrackPresenter < ApplicationPresenter
  def played_at
    h.format_datetime o.played_at
  end

  def title
    h.truncate o.title
  end

  def info
    "#{artist} - #{title}"
  end

  def artist
    h.truncate o.artist
  end

  def album
    h.truncate track_info&.album
  end

  def main_tag
    h.truncate Array(track_info&.tags).first
  end

  def youtube_url
    "https://www.youtube.com/watch?v=#{track_info&.youtube_id}" if track_info&.youtube_id
  end

  def youtube_link
    youtube_url ? h.link_to("youtube", youtube_url) : ""
  end

  def year
    track_info&.year
  end

  delegate :track_info, to: :o
end

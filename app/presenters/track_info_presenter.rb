class TrackInfoPresenter < ApplicationPresenter
  def title
    h.truncate o.name
  end

  def info
    "#{artist_name} - #{title}"
  end

  def artist
    h.truncate o.artist_name
  end

  def album
    h.truncate o.album
  end

  def main_tag
    h.truncate Array(tags).first&.titleize
  end

  def youtube_url
    "https://www.youtube.com/watch?v=#{youtube_id}" if youtube_id.present?
  end

  def youtube_link
    youtube_url ? h.link_to("youtube", youtube_url) : ""
  end
end

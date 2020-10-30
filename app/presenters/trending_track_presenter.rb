class TrendingTrackPresenter < ApplicationPresenter
  delegate :artist_name, :main_tag, :youtube_link, :name, to: :track_info

  def track_info
    @track_info ||= TrackInfoPresenter.new TrackInfo.find_by(slug: o.slug)
  end

  def stations
    Track.where(slug: o.slug).pluck(:station_id).uniq.count
  end

  def first_played_at
    h.format_datetime Track.where(slug: o.slug).first.created_at
  end
end

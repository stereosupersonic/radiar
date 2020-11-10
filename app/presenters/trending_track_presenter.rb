class TrendingTrackPresenter < ApplicationPresenter
  delegate :artist_name, :main_tag, :youtube_link, :year, :name, to: :track_info, allow_nil: true

  def track_info
    return unless track_info_record
    TrackInfoPresenter.new track_info_record
  end

  def track_info_record
    @track_info_record ||= TrackInfo.find_by(slug: o.slug)
  end

  def stations
    track_info.stations.count
  end

  def id
    Track.where(slug: o.slug).pluck(:id).first
  end

  def first_played_at
    h.format_datetime Track.where(slug: o.slug).first.created_at
  end
end

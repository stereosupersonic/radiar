class TrackPresenter < ApplicationPresenter
  delegate :info, :artist, :title, :album, :main_tag, :youtube_link, :year, to: :track_info

  def played_at
    h.format_datetime o.played_at
  end

  def track_info
    @track_info ||= TrackInfoPresenter.new o.track_info
  end

  def station_name
    o.station.name
  end
end

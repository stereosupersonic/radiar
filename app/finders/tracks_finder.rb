class TracksFinder
  include ActiveModel::Model

  FILTERS = %i[year artist station_id tag]
  attr_accessor :per_page, :page
  attr_accessor(*FILTERS)

  def call
    Track
      .order("ID DESC")
      .merge(year_filter)
      .merge(station_filter)
      .merge(artist_filter)
      .merge(tag_filter)
      .paginate(page: page, per_page: per_page)
  end

  private

  def year_filter
    if year.present?
      Track.joins(:track_info).where("track_infos.year = ?", year)
    else
      Track.all
    end
  end

  def artist_filter
    if artist.present?
      Track.where(artist: artist)
    else
      Track.all
    end
  end

  def station_filter
    if station_id.present?
      Track.where(station_id: station_id)
    else
      Track.all
    end
  end

  def tag_filter
    if tag.present?
      # TODO 
    else
      Track.all
    end
  end
end

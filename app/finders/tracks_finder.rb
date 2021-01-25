class TracksFinder
  include ActiveModel::Model
  include ActiveModel::Attributes

  FILTERS = %i[year artist station_id tag first_seen_on more_stations].freeze
  attr_accessor(*FILTERS)

  def call
    Track
      .order("ID DESC")
      .merge(year_filter)
      .merge(station_filter)
      .merge(artist_filter)
      .merge(tag_filter)
      .merge(first_seen_filter)
      .merge(more_stations_filter)
  end

  private
    def year_filter
      if year.present?
        if year.to_s == "without"
          Track.joins(:track_info).where("track_infos.year IS NULL")
        else
          Track.joins(:track_info).where("track_infos.year = ?", year)
        end
      else
        Track.all
      end
    end

    def first_seen_filter
      if first_seen_on.present?
        Track
          .where(slug: Track.select(:slug)
          .having("MIN(played_at) >= ?", first_seen_on.to_date)
          .group(:slug))
      else
        Track.all
      end
    end

    def artist_filter
      if artist.present?
        Track.where("artist ILIKE ?", "%#{artist.squish}%")
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

    def more_stations_filter
      if more_stations
        if first_seen_on.present? && station_id.blank?
          Track
          .having("count(distinct station_id) > 1")
          .group(:slug)
        else
          Track
          .where(slug: Track.select(:slug)
          .having("count(distinct station_id) > 1")
          .group(:slug))
        end
      else
        Track.all
      end
    end

    def tag_filter
      if tag.present?
        Track.joins(:track_info).where("? = ANY (track_infos.tags)", tag)
      else
        Track.all
      end
    end
end

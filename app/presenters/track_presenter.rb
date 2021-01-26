class TrackPresenter < ApplicationPresenter
  delegate :info, :album, :main_tag, :youtube_link, :year, :mbid,
   :spotify_id, :wikidata_id, :artist_wikidata_id, :artist_spotify_id, :artist_mbid,
   :album_wikidata_id, :album_spotify_id, :artist_mbid,  to: :track_info, allow_nil: true

  def played_at
    h.format_datetime o.played_at
  end

  def track_info
    return unless o.track_info

    @track_info ||= TrackInfoPresenter.new o.track_info
  end

  def station_name
    o.station.name
  end

  def artist
    track_info ? track_info.artist_name : o.artist
  end

  def title
    track_info ? track_info.title : o.title
  end

  def full_name
    "#{artist} - #{title}"
  end
end

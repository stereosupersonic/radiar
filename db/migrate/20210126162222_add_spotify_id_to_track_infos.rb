class AddSpotifyIdToTrackInfos < ActiveRecord::Migration[6.0]
  def change
    add_column :track_infos, :spotify_id, :string
    add_column :track_infos, :wikidata_id, :string

    add_column :track_infos, :artist_wikidata_id, :string
    add_column :track_infos, :artist_spotify_id, :string
    add_column :track_infos, :artist_mbid, :string

    add_column :track_infos, :album_wikidata_id, :string
    add_column :track_infos, :album_spotify_id, :string
    add_column :track_infos, :album_mbid, :string
  end
end

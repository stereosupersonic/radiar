# == Schema Information
#
# Table name: track_infos
#
#  id                 :bigint           not null, primary key
#  album              :string
#  album_mbid         :string
#  artist_mbid        :string
#  artist_name        :string           not null
#  ignored            :boolean          default(FALSE), not null
#  mbid               :string
#  name               :string           not null
#  pic_url            :string
#  slug               :string           not null
#  tags               :text             default([]), is an Array
#  wikipedia          :text
#  wikipedia_summary  :text
#  year               :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  album_spotify_id   :string
#  album_wikidata_id  :string
#  artist_spotify_id  :string
#  artist_wikidata_id :string
#  spotify_id         :string
#  wikidata_id        :string
#  youtube_id         :string
#
# Indexes
#
#  index_track_infos_on_slug  (slug)
#  index_track_infos_on_year  (year)
#
class TrackInfo < ApplicationRecord
  has_many :tracks
end

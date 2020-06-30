# == Schema Information
#
# Table name: track_infos
#
#  id                :bigint           not null, primary key
#  album             :string
#  artist_name       :string           not null
#  mbid              :string
#  name              :string           not null
#  pic_url           :string
#  slug              :string
#  tags              :text             default([]), is an Array
#  wikipedia         :text
#  wikipedia_summary :text
#  year              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  youtube_id        :string
#
# Indexes
#
#  index_track_infos_on_slug  (slug)
#  index_track_infos_on_year  (year)
#
class TrackInfo < ApplicationRecord
  has_one :track
end

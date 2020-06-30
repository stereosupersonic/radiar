# == Schema Information
#
# Table name: tracks
#
#  id            :bigint           not null, primary key
#  artist        :string           not null
#  played_at     :datetime         not null
#  response      :text
#  slug          :string           not null
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  station_id    :bigint           not null
#  track_info_id :bigint
#
# Indexes
#
#  index_tracks_on_slug           (slug)
#  index_tracks_on_station_id     (station_id)
#  index_tracks_on_track_info_id  (track_info_id)
#
# Foreign Keys
#
#  fk_rails_...  (station_id => stations.id)
#
class Track < ApplicationRecord
  belongs_to :station
  belongs_to :track_info, optional: true

  delegate :year, to: :track_info, allow_nil: true
  delegate :album, to: :track_info, allow_nil: true
  delegate :pic_url, to: :track_info, allow_nil: true
  delegate :youtube_id, to: :track_info, allow_nil: true

  def youtube_link
    "https://www.youtube.com/watch?v=#{youtube_id}" if youtube_id
  end
end

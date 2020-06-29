# == Schema Information
#
# Table name: tracks
#
#  id         :bigint           not null, primary key
#  artist     :string
#  played_at  :datetime
#  response   :text
#  slug       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  station_id :bigint           not null
#
# Indexes
#
#  index_tracks_on_slug        (slug)
#  index_tracks_on_station_id  (station_id)
#
# Foreign Keys
#
#  fk_rails_...  (station_id => stations.id)
#
class Track < ApplicationRecord
  belongs_to :station
end

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
require "rails_helper"

RSpec.describe Track, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

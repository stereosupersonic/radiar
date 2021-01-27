# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  data          :jsonb
#  done_at       :datetime
#  duration      :float
#  meta_data     :jsonb
#  name          :string           not null
#  state         :string           default("ok"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  station_id    :bigint
#  track_id      :bigint
#  track_info_id :integer
#
# Indexes
#
#  index_events_on_name        (name)
#  index_events_on_state       (state)
#  index_events_on_station_id  (station_id)
#  index_events_on_track_id    (track_id)
#
# Foreign Keys
#
#  fk_rails_...  (track_id => tracks.id)
#
FactoryBot.define do
  factory :event do
    name { "google" }
    state { :ok }
    meta_data { { ip: "192.168.1.1" } }
    data { { a: 1, b: 2 } }
    done_at { Time.current }
  end
end

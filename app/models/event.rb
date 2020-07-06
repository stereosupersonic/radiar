# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  done_at    :datetime
#  duration   :float
#  meta_data  :jsonb
#  name       :string           not null
#  state      :string           default("ok"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  track_id   :bigint
#
# Indexes
#
#  index_events_on_name      (name)
#  index_events_on_state     (state)
#  index_events_on_track_id  (track_id)
#
# Foreign Keys
#
#  fk_rails_...  (track_id => tracks.id)
#
class Event < ApplicationRecord
  STATES = %w[ok failed]
  validates :name, presence: true
  validates :state, presence: true, inclusion: {in: STATES}

  belongs_to :track
end

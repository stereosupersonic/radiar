# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  done_at    :datetime
#  name       :string           not null
#  payload    :jsonb
#  state      :string           default("ok"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_events_on_name   (name)
#  index_events_on_state  (state)
#
class Event < ApplicationRecord
  STATES = %w[ok failed]
  validates :name, presence: true
  validates :state, presence: true, inclusion: {in: STATES}
end

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
FactoryBot.define do
  factory :event do
    name { "google" }
    state { :ok }
    payload { {ip: "192.168.1.1", data: {a: 1, b: 2}} }
    done_at { Time.current }
  end
end

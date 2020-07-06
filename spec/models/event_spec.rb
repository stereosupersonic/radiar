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
require "rails_helper"

RSpec.describe Event, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:state) }

  it "has a valid factory" do
    event = FactoryBot.build :event

    expect(event).to be_valid
    assert event.save!
  end

  it "should not be valid with an unknow state" do
    event = FactoryBot.build :event, state: "blahblah"

    expect(event).to be_invalid
  end
end
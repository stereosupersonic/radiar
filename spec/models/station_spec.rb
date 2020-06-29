# == Schema Information
#
# Table name: stations
#
#  id             :bigint           not null, primary key
#  enabled        :boolean          default(TRUE)
#  last_logged_at :datetime
#  name           :string
#  playlist_url   :string
#  strategy       :string
#  url            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_stations_on_last_logged_at  (last_logged_at)
#
require "rails_helper"

RSpec.describe Station, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:playlist_url) }
  it { is_expected.to validate_presence_of(:strategy) }

  it "has a valid factory" do
    station = FactoryBot.build :station
    expect(station).to be_valid
  end
end
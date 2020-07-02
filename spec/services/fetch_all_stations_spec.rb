require "rails_helper"

RSpec.describe FetchAllStations do
  it "should have enqueued jobs" do
    station_1 = FactoryBot.create :station
    station_2 = FactoryBot.create :station

    FetchAllStations.call

    expect(FetchStationJob).to have_been_enqueued.with(station_1.id)
    expect(FetchStationJob).to have_been_enqueued.with(station_2.id)
  end
end

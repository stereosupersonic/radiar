require "rails_helper"

RSpec.describe FetchAllStations do
  it "should have enqueued jobs" do
    station_1 = FactoryBot.create :station
    station_2 = FactoryBot.create :station
    station_3 = FactoryBot.create :station, enabled: false

    expect(FetchStationJob).to receive(:perform_later).with(station_1.id)
    expect(FetchStationJob).to receive(:perform_later).with(station_2.id)
    expect(FetchStationJob).to_not receive(:perform_later).with(station_3.id)

    FetchAllStations.call
  end
end

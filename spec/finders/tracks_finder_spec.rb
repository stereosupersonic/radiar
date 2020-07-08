require "rails_helper"

RSpec.describe TracksFinder do
  let(:track) { FactoryBot.create :track }

  context "year" do
    it "should find a track" do
      track = FactoryBot.create :track
      FactoryBot.create :track_info, year: 2020, track: track

      expect(TracksFinder.new(year: 2020).call).to eq([track])
      expect(TracksFinder.new(year: 2021).call).to eq([])
    end
  end

  context "station" do
    it "should find a track" do
      station = FactoryBot.create :station
      track = FactoryBot.create :track, station: station

      expect(TracksFinder.new(station_id: station.id).call).to eq([track])
      expect(TracksFinder.new(station_id: 666).call).to eq([])
    end
  end
end

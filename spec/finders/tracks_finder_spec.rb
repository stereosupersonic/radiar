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

  context "tag" do
    it "should find a track" do
      track = FactoryBot.create :track
      FactoryBot.create :track_info, year: 2020, track: track, tags: ["metal", "pop"]

      expect(TracksFinder.new(tag: "metal").call).to eq([track])
      expect(TracksFinder.new(tag: "ska").call).to eq([])
    end
  end

  context "first_seen" do
    it "should find a track thats first seen after a date" do
      FactoryBot.create :track, created_at: 1.month.ago, slug: :test1
      FactoryBot.create :track, created_at: 1.day.ago, slug: :test1
      FactoryBot.create :track, created_at: 2.days.ago, slug: :test2
      FactoryBot.create :track, created_at: 1.day.ago, slug: :test2

      expect(TracksFinder.new(first_seen_on: 1.week.ago).call.first.slug).to eq "test2"
      expect(TracksFinder.new(first_seen_on: 1.week.ago).call.size).to eq 2
      expect(TracksFinder.new(first_seen_on: 1.week.ago).call.reorder("").group("slug").count).to eq({"test2" => 2})
    end
  end
end

require "rails_helper"

RSpec.describe FetchStationJob, type: :job do
  subject(:job) { FetchStationJob.new }

  let!(:station) do
    FactoryBot.create(:station,
      name: "Absolute Radio",
      url: "https://planetradio.co.uk/absolute-radio/",
      playlist_url: "https://onlineradiobox.com/uk/absolute1058/playlist/",
      strategy: "radiobox")
  end

  it "creates a new track and track info" do
    expect {
      VCR.use_cassette("services/create_valid_track") do
        job.perform(station.id)
      end

      expect(GoogleJob).to have_been_enqueued
      expect(LastfmJob).to have_been_enqueued

      # TODO: disabled MusicGraph
      # expect(MusicGraphJob).to have_been_enqueued
    }.to change(Track, :count).by(1).and change(TrackInfo, :count).by(1)
  end

  it "does nothing when station not exists" do
    expect {
      job.perform(666)
    }.to change(Track, :count).by(0).and change(TrackInfo, :count).by(0)
  end
end

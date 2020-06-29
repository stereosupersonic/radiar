require "rails_helper"

RSpec.describe CreateTrack do
  let(:station) {
    FactoryBot.create(:station,
      name: "Absolute Radio",
      url: "https://planetradio.co.uk/absolute-radio/",
      playlist_url: "https://onlineradiobox.com/uk/absolute1058/playlist/",
      strategy: "radiobox")
  }

  it "creates a vaild track" do
    expect {
      VCR.use_cassette("services/create_valid_track") do
        CreateTrack.new(station).call
      end
    }.to change(Track, :count).by(1)
    track = Track.last
    expect(track.artist).to eq("Queen")
    expect(track.title).to eq("Radio Gaga")
    expect(track.slug).to eq("queenradiogaga")
    expect(track.played_at.to_date).to eq Time.current.to_date
    expect(track.response).to eq("<a href=\"/track/3184271/\" class=\"ajax\">Queen - Radio Gaga</a>")

    expect(station.last_logged_at.to_date).to eq Time.current.to_date
  end

  it "don't create a entry when the last song is the same" do
    create(:track, station: station, slug: "queenradiogaga")

    expect {
      VCR.use_cassette("services/create_valid_track") do
        CreateTrack.new(station).call
      end
    }.to_not change(Track, :count)
  end
end

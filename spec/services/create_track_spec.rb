require "rails_helper"

RSpec.describe CreateTrack do
  let(:station) do
    FactoryBot.create(:station,
      name: "Absolute Radio",
      url: "https://planetradio.co.uk/absolute-radio/",
      playlist_url: "https://onlineradiobox.com/uk/absolute1058/playlist/",
      strategy: "radiobox")
  end

  it "should work with a new selector" do
    track = nil
    station = Station.create(
      name: "Marilu",
      url: "https://www.marilu.it/",
      playlist_url: "https://onlineradiobox.com/it/marilu/playlist/",
      strategy: "radiobox"
    )

    expect {
      VCR.use_cassette("services/create_invalid_track") do
        track = CreateTrack.new(station: station).call
      end
    }.to change(Track, :count).by(1)

    expect(track.artist).to eq("Iron Maiden")
    expect(track.title).to eq("Moonchild")
    expect(track.slug).to eq("ironmaidenmoonchild")
    expect(track.played_at.to_date).to eq Time.current.to_date
    expect(track.response).to eq("<td>IRON MAIDEN - MOONCHILD</td>")

    expect(station.last_logged_at.to_date).to eq Time.current.to_date
  end

  it "creates a vaild track" do
    track = nil
    expect {
      VCR.use_cassette("services/create_valid_track") do
        track = CreateTrack.new(station: station).call
      end
    }.to change(Track, :count).by(1)

    expect(track.artist).to eq("Queen")
    expect(track.title).to eq("Radio Gaga")
    expect(track.slug).to eq("queenradiogaga")
    expect(track.played_at.to_date).to eq Time.current.to_date
    expect(track.response).to eq "<td><a href=\"/track/3184271/\" class=\"ajax\">Queen - Radio Gaga</a></td>"

    expect(station.last_logged_at.to_date).to eq Time.current.to_date
  end

  it "creates a vaild track when artist and title is seperated by :" do
    station.update! playlist_url: "https://onlineradiobox.com/de/starfm879/playlist/"

    track = nil
    expect {
      VCR.use_cassette("services/create_valid_track_two") do
        track = CreateTrack.new(station: station).call
      end
    }.to change(Track, :count).by(1)

    expect(track.artist).to eq("Led Zeppelin")
    expect(track.title).to eq("Ramble On (2007 Remaster)")
  end

  it "don't create a entry when the last song is the same" do
    track = nil
    create(:track, station: station, slug: "queenradiogaga")

    expect {
      VCR.use_cassette("services/create_valid_track") do
        track = CreateTrack.new(station: station).call
      end
    }.to_not change(Track, :count)

    expect(track).to be_nil
  end
end

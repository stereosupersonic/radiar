require "rails_helper"

RSpec.describe CreateTrackInfo do
  let(:track) { FactoryBot.create :track }

  it "builds a new track_info when not exits" do
    expect {
      CreateTrackInfo.new(track).call
    }.to change(TrackInfo, :count).by(1)
    track_info = TrackInfo.last

    expect(track_info.slug).to eq track.slug
    expect(track_info.name).to eq "Once"
    expect(track_info.artist_name).to eq "Liam Gallagher"
    expect(track_info.year).to be_nil
    expect(track_info.album).to be_nil
    expect(track_info.pic_url).to be_nil
    expect(track_info.mbid).to be_nil
    expect(track_info.tags).to be_empty
    expect(track_info.youtube_id).to be_nil
    expect(track_info.wikipedia).to be_nil
    expect(track_info.wikipedia_summary).to be_nil
  end

  it "don't creates in if there is exiting one with slug" do
    track = FactoryBot.create :track, track_info: nil
    track_info = FactoryBot.create :track_info, slug: track.slug

    expect {
      CreateTrackInfo.new(track).call
    }.to_not change(TrackInfo, :count)

    expect(track.reload.track_info).to eq track_info
  end

  it "don't creates in if there is exiting" do
    FactoryBot.create :track_info, track: track

    expect {
      CreateTrackInfo.new(track).call
    }.to_not change(TrackInfo, :count)

    expect(track.reload.track_info).to be_present
  end
end

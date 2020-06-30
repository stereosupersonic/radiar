require "rails_helper"

RSpec.describe MusicGraphJob, type: :job do
  subject(:job) { MusicGraphJob.new }

  let(:track) { FactoryBot.create :track }

  it "builds a new track_info when not exits" do
    expect {
      VCR.use_cassette("jobs/fetch_music_graph_api") do
        job.perform(track.id)
      end
    }.to change(TrackInfo, :count).by(1)
    track_info = TrackInfo.last

    expect(track_info.slug).to eq track.slug
    expect(track_info.album).to eq "Once"
    expect(track_info.artist_name).to eq "Liam Gallagher"
    expect(track_info.year).to eq 2019
    expect(track_info.name).to eq "Once"
    expect(track_info.youtube_id).to eq "MDhiQfekdxo"
    expect(track_info.pic_url).to eq "https://img.youtube.com/vi/MDhiQfekdxo/hqdefault.jpg"
  end

  it "don't build a new info if slug exits" do
    track_info = FactoryBot.create :track_info, slug: track.slug

    expect {
      job.perform(track.id)
    }.to_not change(TrackInfo, :count)

    expect(track.reload.track_info).to eq(track_info)
  end

  it "fail if key is missing", focus: true do
    expect {
      VCR.use_cassette("jobs/missing_api_key_music_graph_api") do
        job.perform(track.id)
      end
    }.to raise_error("MusicAPI Error - code:401 message:Unauthorized")
  end
end

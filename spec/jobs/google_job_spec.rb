require "rails_helper"

RSpec.describe GoogleJob, type: :job do
  subject(:job) { GoogleJob.new }

  let(:track) { FactoryBot.create :track }
  let(:track_info) { FactoryBot.create :track_info, track: track, year: nil, album: nil, youtube_id: nil }

  it "set the missing values" do
    VCR.use_cassette("jobs/fetch_google") do
      job.perform(track_info.id)
    end

    track_info.reload

    expect(track_info.album).to eq "Once"
    expect(track_info.artist_name).to eq "Liam Gallagher"
    expect(track_info.year).to eq 2019
    expect(track_info.name).to eq "Once"
    expect(track_info.tags).to eq ["Alternative/Indie"]
  end

  it "don't override existing values" do
    track_info = FactoryBot.create :track_info, slug: track.slug, pic_url: "1234", year: 2020, album: "test", tags: %w[rock pop]

    expect {
      job.perform(track_info.id)
    }.to_not change(TrackInfo, :count)

    track_info.reload

    expect(track_info.album).to eq "test"
    expect(track_info.artist_name).to eq "Liam Gallagher"
    expect(track_info.year).to eq 2020
    expect(track_info.tags).to eq(["rock", "pop"])
  end
end
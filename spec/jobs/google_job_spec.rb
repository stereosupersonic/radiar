require "rails_helper"

RSpec.describe GoogleJob, type: :job do
  subject(:job) { GoogleJob.new }

  let!(:track) { FactoryBot.create :track, track_info: track_info }
  let(:track_info) { FactoryBot.create :track_info, year: nil, album: nil, youtube_id: nil }

  it "creates an event" do
    expect {
      VCR.use_cassette("jobs/fetch_google") do
        job.perform(track: track, track_info: track_info)
      end
    }.to have_enqueued_job.with(hash_including(name: :google_search, state: "ok")).on_queue("low")
  end

  it "creates an event with no data" do
    track_info = FactoryBot.create :track_info, year: nil, album: nil, youtube_id: nil
    track = FactoryBot.create :track, artist: "Metallica", title: "Metallica", track_info: track_info
    expect {
      VCR.use_cassette("jobs/google_no_data") do
        job.perform(track: track, track_info: track_info)
      end
    }.to have_enqueued_job.with(hash_including(name: :google_search, state: "no_data")).on_queue("low")
  end

  it "set the missing values" do
    VCR.use_cassette("jobs/fetch_google") do
      job.perform(track: track, track_info: track_info)
    end

    track_info.reload

    expect(track_info.album).to eq "Once"
    expect(track_info.artist_name).to eq "Liam Gallagher"
    expect(track_info.year).to eq 2019
    expect(track_info.name).to eq "Once"
    expect(track_info.tags).to eq %w[rock pop]
  end

  it "don't override existing values" do
    track_info = FactoryBot.create :track_info, slug: track.slug, pic_url: "1234", year: 2020, album: "test", tags: %w[rock pop]
    track = FactoryBot.create :track, artist: "Metallica", title: "Metallica", track_info: track_info
    expect {
      job.perform(track: track, track_info: track_info)
    }.to_not change(TrackInfo, :count)

    track_info.reload

    expect(track_info.album).to eq "test"
    expect(track_info.artist_name).to eq "Liam Gallagher"
    expect(track_info.year).to eq 2020
    expect(track_info.tags).to eq(%w[rock pop])
  end

  xit "fetch album data when song is also album title" do
    track = FactoryBot.create :track, artist: "Metallica", title: "Metallica"
    track_info = FactoryBot.create :track_info, track: track, year: nil, album: nil, youtube_id: nil

    VCR.use_cassette("jobs/fetch_album") do
      job.perform(track: track, track_info: track_info)
    end

    track_info.reload

    expect(track_info.album).to eq "Master of Puppets"
    expect(track_info.artist_name).to eq "Metallica"
    expect(track_info.year).to eq 2019
    expect(track_info.name).to eq "Once"
    expect(track_info.tags).to eq ["Alternative/Indie"]
  end
end

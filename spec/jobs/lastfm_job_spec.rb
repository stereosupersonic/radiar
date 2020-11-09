require "rails_helper"

RSpec.describe LastfmJob, type: :job do
  subject(:job) { LastfmJob.new }

  let(:track) { FactoryBot.create :track }
  let(:track_info) { FactoryBot.create :track_info, track: track, year: nil, tags: [], album: nil, youtube_id: nil }

  it "enques an event" do
    expect {
      VCR.use_cassette("jobs/fetch_lastfm") do
        job.perform(track_info.id)
      end
    }.to have_enqueued_job.with(hash_including(name: :last_fm_api, state: "ok")).on_queue("low")
  end

  it "set the missing values" do
    VCR.use_cassette("jobs/fetch_lastfm") do
      job.perform(track_info.id)
    end

    track_info.reload

    expect(track_info.album).to eq "Once"
    expect(track_info.artist_name).to eq "Liam Gallagher"
    expect(track_info.name).to eq "Once"
    expect(track_info.tags).to eq %w[britpop 2010s 2019]
  end

  it "override existing values" do
    track_info = FactoryBot.create(
      :track_info, track: track, slug: track.slug, pic_url: "1234", year: 2020, album: "test", tags: %w[rock pop]
    )

    expect {
      VCR.use_cassette("jobs/fetch_lastfm") do
        job.perform(track_info.id)
      end
    }.to_not change(TrackInfo, :count)

    track_info.reload

    expect(track_info.album).to eq "test"
    expect(track_info.artist_name).to eq "Liam Gallagher"
    expect(track_info.year).to eq 2020
    expect(track_info.tags).to eq(%w[britpop 2010s 2019])
  end
end

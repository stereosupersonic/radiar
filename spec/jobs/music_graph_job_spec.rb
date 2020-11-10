require "rails_helper"

RSpec.describe MusicGraphJob, type: :job do
  subject(:job) { MusicGraphJob.new }

  let(:track) { FactoryBot.create :track, track_info: track_info }
  let(:track_info) { FactoryBot.create :track_info, year: nil, album: nil, youtube_id: nil }

  it "enques an event" do
    expect {
      VCR.use_cassette("jobs/fetch_music_graph_api") do
        job.perform(track: track)
      end
    }.to have_enqueued_job.with(hash_including(name: :musci_graph_api, state: "ok")).on_queue("low")
  end

  it "set the missing values" do
    VCR.use_cassette("jobs/fetch_music_graph_api") do
      job.perform(track: track)
    end

    track_info.reload

    expect(track_info.album).to eq "Once"
    expect(track_info.artist_name).to eq "Liam Gallagher"
    expect(track_info.year).to eq 2019
    expect(track_info.name).to eq "Once"
    expect(track_info.youtube_id).to eq "MDhiQfekdxo"
    expect(track_info.pic_url).to eq "https://img.youtube.com/vi/MDhiQfekdxo/hqdefault.jpg"
  end

  it "don't override existing values" do
    track_info = FactoryBot.create :track_info, slug: track.slug, pic_url: "1234", year: 2020, album: "test", youtube_id: "123"
    track = FactoryBot.create :track, track_info: track_info
    expect {
      job.perform(track: track)
    }.to_not change(TrackInfo, :count)

    track_info.reload

    expect(track_info.album).to eq "test"
    expect(track_info.artist_name).to eq "Liam Gallagher"
    expect(track_info.year).to eq 2020
    expect(track_info.pic_url).to eq "1234"
    expect(track_info.youtube_id).to eq "123"
  end

  xit "fail if key is missing and creates an event" do
    expect {
      expect {
        VCR.use_cassette("jobs/missing_api_key_music_graph_api") do
          job.perform(track: track)
        end
      }.to have_enqueued_job.with(hash_including(name: :musci_graph_api, state: "exception")).on_queue("low")
    }.to raise_error(ActiveJob::SerializationError)
  end
end

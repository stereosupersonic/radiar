require "rails_helper"

RSpec.describe CreateTrackInfo do
  let(:track) { FactoryBot.create :track }

  before { ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true }

  it "builds a new track_info when not exits" do
    expect {
      expect {
        expect {
          CreateTrackInfo.new(track).call
        }.to change(TrackInfo, :count).by(1)
      }.to change(Event, :count).by 1
    }.to have_performed_job(CreateEventJob)
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

    event = Event.last

    expect(event.name).to eq "track_info_created"
    expect(event.data.symbolize_keys).to eq({
      artist: "Liam Gallagher",
      title: "Once",
      track_info: track_info.id
    })
    expect(event.track).to eq track
  end

  it "don't creates in if there is exiting one with slug" do
    track = FactoryBot.create :track, track_info: nil
    track_info = FactoryBot.create :track_info, slug: track.slug
    expect {
      expect {
        expect {
          CreateTrackInfo.new(track).call
        }.to_not change(TrackInfo, :count)
      }.to change(Event, :count).by 1
    }.to have_performed_job(CreateEventJob)
    event = Event.last

    expect(event.name).to eq "track_info_exits"
    expect(event.data.symbolize_keys).to eq({
      artist: "Liam Gallagher",
      title: "Once",
      track_info: track_info.id
    })
    expect(event.track).to eq track
  end

  it "don't creates in if there is exiting" do
    FactoryBot.create :track_info, track: track
    expect {
      expect {
        expect {
          CreateTrackInfo.new(track).call
        }.to_not change(TrackInfo, :count)
      }.to_not change(Event, :count)
    }.to_not have_performed_job(CreateEventJob)

    expect(track.reload.track_info).to be_present
  end
end

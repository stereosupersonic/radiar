class FetchStationJob < ApplicationJob
  queue_as :default

  def perform(station_id)
    station = Station.find station_id
    track = CreateTrack.new(station).call
    MusicGraphJob.perform_later(track.id) if track
  end
end

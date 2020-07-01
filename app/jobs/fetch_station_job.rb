class FetchStationJob < ApplicationJob
  queue_as :default

  def perform(station_id)
    station = Station.find station_id
    track = CreateTrack.new(station).call
    track_info = CreateTrackInfo.new(track).call

    GoogleJob.perform_later(track_info.id) if track_info
    MusicGraphJob.perform_later(track_info.id) if track_info
  end
end

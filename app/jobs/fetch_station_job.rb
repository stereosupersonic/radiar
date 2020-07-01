class FetchStationJob < ApplicationJob
  queue_as :default

  def perform(station_id)
    station = Station.find_by id: station_id
    return unless station

    track = CreateTrack.new(station: station).call
    return unless track

    track_info = CreateTrackInfo.new(track).call
    return unless track_info

    GoogleJob.perform_later(track_info.id)
    MusicGraphJob.perform_later(track_info.id)
  end
end

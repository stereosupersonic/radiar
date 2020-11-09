class FetchStationJob < ApplicationJob
  queue_as :critical

  def perform(station_id)
    station = Station.find_by id: station_id
    return unless station

    track = CreateTrack.new(station: station).call
    return unless track

    track_info = CreateTrackInfo.new(track).call
    return unless track_info

    # google doesn't find the informatio when the track is called like the album

    GoogleJob.perform_later(track_info.id)
    # TODO: disabled MusicGraph
    # MusicGraphJob.perform_later(track_info.id)
    LastfmJob.perform_later(track_info.id)
  end
end

class FetchStationJob < ApplicationJob
  queue_as :critical

  def perform(station)
    return unless station

    track = CreateTrack.new(station: station).call
    return unless track

    track_info = CreateTrackInfo.new(track).call
    return unless track_info

    # google doesn't find the informatio when the track is called like the album

    WikiDataJob.perform_later(track: track, track_info: track_info)
    GoogleJob.perform_later(track: track, track_info: track_info)
    # TODO: disabled MusicGraph
    # MusicGraphJob.perform_later(track: track)
    LastfmJob.perform_later(track: track, track_info: track_info)
  end
end

class Admin::FetchTrackInfosController < ApplicationController

  def update
    track = Track.find params[:id]


    GoogleJob.perform_later(track: track, track_info: track.track_info)
    LastfmJob.perform_later(track: track, track_info: track.track_info)

    redirect_to track_path(track)
  end
end

class Admin::FetchTrackInfosController < ApplicationController
  def update
    track_info = TrackInfo.find params[:id]

    WikiDataJob.perform_later(track_info: track_info)
    GoogleJob.perform_later(track_info: track_info)
    LastfmJob.perform_later(track_info: track_info)

    redirect_to track_info_path(track_info)
  end
end

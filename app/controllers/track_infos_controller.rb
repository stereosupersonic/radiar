class TrackInfosController < ApplicationController
  def show
    track_info_record = TrackInfo.find params[:id]
    @track_info = TrackInfoPresenter.new track_info_record
  end

  def index
  end
end

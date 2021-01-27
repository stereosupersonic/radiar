class TracksController < ApplicationController
  def index
    @track_search = TracksFinder.new(search_params)
    @track_records = @track_search.call.paginate(page: params[:page], per_page: params[:per_page])

    @tracks = TrackPresenter.wrap @track_records
  end

  def show
    @track = TrackPresenter.new Track.find(params[:id])
  end

  private
    def search_params
      if params[:track_info_id].present?
        params.permit(:track_info_id)
      else
        params[:tracks_finder]&.permit(*TracksFinder::FILTERS)
      end
    end
end

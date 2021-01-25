class Admin::TrackEventsController < ApplicationController
  before_action :load_track
  def index
    @event_records = Event.where(track_id: @track.id).order("ID DESC").paginate(page: params[:page])
    @events = Admin::EventPresenter.wrap @event_records
  end

  def show
    event_records = Event.find params[:id]
    @event = Admin::EventPresenter.new event_records
  end

  private
    def load_track
      @track ||= TrackPresenter.new(Track.find(params[:track_id]))
    end
end

class Admin::EventsController < ApplicationController
  def index
    @event_records = Event.order("ID DESC").paginate(page: params[:page])
    @events = Admin::EventPresenter.wrap @event_records
  end

  def show
    event_records = Event.find params[:id]
    @event = Admin::EventPresenter.new event_records
  end
end

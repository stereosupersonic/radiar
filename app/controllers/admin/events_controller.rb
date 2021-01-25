class Admin::EventsController < ApplicationController
  def index
    @event_search = EventsFinder.new(search_params)
    @event_records = @event_search.call.paginate(page: params[:page], per_page: params[:per_page])

    @events = Admin::EventPresenter.wrap @event_records
  end

  def show
    event_records = Event.find params[:id]
    @event = Admin::EventPresenter.new event_records
  end

  private
    def search_params
      params[:events_finder]&.permit(*EventsFinder::FILTERS)
    end
end

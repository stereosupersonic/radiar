# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @track_search = TracksFinder.new(search_params)
    @track_records = @track_search.call

    @tracks = TrackPresenter.wrap @track_records
  end

  private

  def search_params
    if params[:tracks_finder]
      params[:tracks_finder].permit(*TracksFinder::FILTERS).merge(page: params[:page])
    else
      {page: params[:page]}
    end
  end
end

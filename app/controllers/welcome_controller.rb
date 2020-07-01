# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @track_records = Track.order("id DESC").limit(25)
    @tracks = TrackPresenter.wrap @track_records
  end

  def fetch
    FetchAllStations.new.call
    redirect_to root_path, notice: "Station fetched"
  end
end

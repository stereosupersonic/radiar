# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @tracks = Track.order("id DESC").limit(25)
  end

  def fetch
    FetchAllStations.new.call
    redirect_to root_path, notice: "Station fetched"
  end
end

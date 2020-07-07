# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @track_records = Track.order("id DESC").paginate(page: params[:page])
    @tracks = TrackPresenter.wrap @track_records
  end
end

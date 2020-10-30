# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @trending_tracks = TrendingTrackPresenter.wrap TrendingSongs.new(year: Time.current.year).call
  end
end

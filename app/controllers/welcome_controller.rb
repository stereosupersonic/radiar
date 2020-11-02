# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @trending_tracks_search = TrendingTracks.new(search_params.reverse_merge(first_seen_period: :week))
    @trending_tracks = TrendingTrackPresenter.wrap @trending_tracks_search.call
  end

  private

  def search_params
    if params[:trending_tracks]
      params[:trending_tracks].permit(*TrendingTracks::FILTERS)
    else
      {}
    end
  end
end

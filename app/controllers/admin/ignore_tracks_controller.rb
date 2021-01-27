class Admin::IgnoreTracksController < ApplicationController
  def update
    slug = params[:slug]

    IgnoreTracks.new(slug: slug).call
    redirect_to root_path, notice: "Track: #{slug} is ignored"
  end
end

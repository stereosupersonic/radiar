class Admin::IgnoreTracksController < ApplicationController
  def update
      track = Track.find params[:id]

     if track&.slug.present?
       IgnoreTracks.new(slug: track.slug).call
       redirect_to root_apth, notice: "Track: #{track.slug} is ignored" }
     else
      redirect_to root_apth, notice: "No Track found with id: #{params[:id]}" }
     end

  end
end

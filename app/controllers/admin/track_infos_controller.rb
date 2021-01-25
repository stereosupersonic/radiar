class Admin::TrackInfosController < ApplicationController
  def edit
    @track_info = TrackInfo.find params[:id]
  end

  def update
    @track_info = TrackInfo.find params[:id]

    if       UpdateTrackInfo.new(@track_info, track_info_params).call

      redirect_to tracks_path, notice: "TrackInfo updated"
    else
      render :edit
    end
  end

  private
    def track_info_params
      params
        .require(:track_info)
        .permit(:name, :album, :year, :artist_name,
          :youtube_id,
          :mbid,
          :wikipedia_summary,
          :wikipedia,
          :pic_url)
    end
end

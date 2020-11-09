class Admin::TrackInfosController < ApplicationController
  def edit
    @track_info = TrackInfo.find params[:id]
  end

  def update
    @track_info = TrackInfo.find params[:id]

    if @track_info.update(track_info_params)
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

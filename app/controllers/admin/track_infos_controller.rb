class Admin::TrackInfosController < ApplicationController
  def edit
    @track_info = TrackInfo.find params[:id]
  end

  def update
    @track_info = TrackInfo.find params[:id]

    if UpdateTrackInfo.new(@track_info, track_info_params).call

      redirect_to @track_info, notice: "TrackInfo updated"
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

          :wikidata_id,
          :spotify_id,
           :album_mbid,
            :album_spotify_id,
             :album_wikidata_id,
              :artist_spotify_id,
              :artist_wikidata_id,
          :artist_mbid,
          :pic_url)
    end
end

class Admin::StationsController < ApplicationController
  def index
    @stations = Station.order :name
  end

  def new
    @station = Station.new
  end

  def create
    @station = Station.new(station_params)

    respond_to do |format|
      if @station.save
        format.html { redirect_to admin_stations_path, notice: "Station was successfully created." }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @station = Station.find(params[:id])
  end

  def update
    @station = Station.find(params[:id])
    respond_to do |format|
      if @station.update(station_params)
        format.html { redirect_to admin_stations_path, notice: "Station was successfully updated." }
      else
        format.html { render :edit }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def station_params
    params.require(:station).permit(:name, :strategy, :url, :playlist_url, :enabled)
  end
end

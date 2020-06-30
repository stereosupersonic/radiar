class FetchStationJob < ApplicationJob
  queue_as :default

  def perform(station_id)
    station = Station.find station_id
    CreateTrack.new(station).call
  end
end

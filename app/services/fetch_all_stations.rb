class FetchAllStations < BaseService
  def call
    # TODO: make this more robuts => put to resque
    Station.where(enabled: true).pluck(:id).each do |station_id|
      FetchStationJob.perform_later(station_id)
    end
  end
end

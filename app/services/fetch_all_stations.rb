class FetchAllStations < BaseService
  def call
    # TODO: make this more robuts => put to resque
    Station.where(enabled: true).find_each do |station|
      FetchStationJob.perform_later(station)
    end
  end
end

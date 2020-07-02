class FetchAllStations < BaseService
  def call
    # TODO make this more robuts => put to resque
    Station.where(enabled: true).each do |station|
      FetchStationJob.perform_later(station.id)
    end
  end
end

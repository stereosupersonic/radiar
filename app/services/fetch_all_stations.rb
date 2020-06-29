class FetchAllStations
  def call
    Station.where(enabled: true).each do |station|
      CreateTrack.new(station).call
    end
  end
end

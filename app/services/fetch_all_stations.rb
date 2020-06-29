class FetchAllStations
  def call
    # TODO make this more robuts => put to resque
    Station.where(enabled: true).each do |station|
      CreateTrack.new(station).call
    rescue => e
      Rails.logger.error "Error processing station: #{station.name}", e
    end
  end
end

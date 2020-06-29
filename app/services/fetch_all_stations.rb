class FetchAllStations
  def call
    Station.all.each do |station|
      next if station.disabled?

      Rails.logger.info "fetch station:#{station.name}"
      # TODO: call sidekiq job for each station
      CreateLogEntry.new(station).call
    end
  end
end

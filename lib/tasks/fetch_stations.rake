namespace :radiar do
  desc "fetch all stations"
  task fetch_all: :environment do
    FetchAllStations.new.call
  end
end

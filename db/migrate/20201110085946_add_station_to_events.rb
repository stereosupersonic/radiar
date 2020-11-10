class AddStationToEvents < ActiveRecord::Migration[6.0]
  def change
    add_reference(:events, :station, index: true)
  end
end

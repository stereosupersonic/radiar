class AddLastLoggedAtToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :last_logged_at, :datetime
    add_index :stations, :last_logged_at
  end
end

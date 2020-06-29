class CreateStations < ActiveRecord::Migration[6.0]
  def change
    create_table :stations do |t|
      t.string :name
      t.string :url
      t.string :playlist_url
      t.string :strategy
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end

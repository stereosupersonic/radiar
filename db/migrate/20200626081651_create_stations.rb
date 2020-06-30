class CreateStations < ActiveRecord::Migration[6.0]
  def change
    create_table :stations do |t|
      t.string :name, null: false
      t.string :url
      t.string :playlist_url, null: false
      t.string :strategy, null: false
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end

class CreateTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :tracks do |t|
      t.string :title, null: false
      t.string :artist, null: false
      t.references :station, null: false, foreign_key: true
      t.text :response
      t.string :slug, null: false
      t.datetime :played_at, null: false

      t.timestamps
    end
    add_index :tracks, :slug
  end
end

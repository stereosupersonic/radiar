class CreateTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :artist
      t.references :station, null: false, foreign_key: true
      t.text :response
      t.string :slug
      t.datetime :played_at

      t.timestamps
    end
    add_index :tracks, :slug
  end
end

class CreateTrackInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :track_infos do |t|
      t.string :name, null: false
      t.string :artist_name , null: false
      t.string :album
      t.string :year
      t.string :youtube_id
      t.text :tags, array: true, default: []
      t.text :wikipedia_summary
      t.text :wikipedia
      t.string :mbid
      t.string :slug
   
      t.timestamps
    end
    add_index :track_infos, :slug
    add_reference(:tracks, :track_info)
  end
end

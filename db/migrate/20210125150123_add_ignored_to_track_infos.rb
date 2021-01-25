class AddIgnoredToTrackInfos < ActiveRecord::Migration[6.0]
  def change
    add_column :track_infos, :ignored, :boolean, index: true, default: false, null: false
  end
end

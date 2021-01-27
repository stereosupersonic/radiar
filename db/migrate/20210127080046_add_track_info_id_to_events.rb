class AddTrackInfoIdToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :track_info_id, :integer, index: true
  end
end

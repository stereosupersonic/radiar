class AddTrackToEvents < ActiveRecord::Migration[6.0]
  def change
    add_reference(:events, :track, foreign_key: true, index: true)
  end
end

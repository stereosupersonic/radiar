class CleanupWrongTracks < ActiveRecord::Migration[6.0]
  def up
    Track.where(artist: ["", nil]).or(Track.where(title: ["", nil])).destroy_all
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

class AddNotNullForSlug < ActiveRecord::Migration[6.0]
  def change
    change_column :track_infos, :slug, :string, null: false
  end
end

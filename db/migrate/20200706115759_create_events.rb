class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :state, null: false, default: "ok"
      t.jsonb :data
      t.jsonb :meta_data
      t.datetime :done_at
      t.float :duration
      t.timestamps
    end
    add_index :events, :name
    add_index :events, :state
  end
end

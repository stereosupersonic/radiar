# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_29_134253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "playlist_url"
    t.string "strategy"
    t.boolean "enabled", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "last_logged_at"
    t.index ["last_logged_at"], name: "index_stations_on_last_logged_at"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title"
    t.string "artist"
    t.bigint "station_id", null: false
    t.text "response"
    t.string "slug"
    t.datetime "played_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_tracks_on_slug"
    t.index ["station_id"], name: "index_tracks_on_station_id"
  end

  add_foreign_key "tracks", "stations"
end

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

ActiveRecord::Schema.define(version: 2020_11_03_152921) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "state", default: "ok", null: false
    t.jsonb "data"
    t.jsonb "meta_data"
    t.datetime "done_at"
    t.float "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "track_id"
    t.index ["name"], name: "index_events_on_name"
    t.index ["state"], name: "index_events_on_state"
    t.index ["track_id"], name: "index_events_on_track_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name", null: false
    t.string "url"
    t.string "playlist_url", null: false
    t.string "strategy", null: false
    t.boolean "enabled", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "last_logged_at"
    t.index ["last_logged_at"], name: "index_stations_on_last_logged_at"
  end

  create_table "track_infos", force: :cascade do |t|
    t.string "name", null: false
    t.string "artist_name", null: false
    t.string "album"
    t.integer "year"
    t.string "youtube_id"
    t.text "tags", default: [], array: true
    t.text "wikipedia_summary"
    t.text "wikipedia"
    t.string "mbid"
    t.string "slug", null: false
    t.string "pic_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_track_infos_on_slug"
    t.index ["year"], name: "index_track_infos_on_year"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title", null: false
    t.string "artist", null: false
    t.bigint "station_id", null: false
    t.text "response"
    t.string "slug", null: false
    t.datetime "played_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "track_info_id"
    t.index ["slug"], name: "index_tracks_on_slug"
    t.index ["station_id"], name: "index_tracks_on_station_id"
    t.index ["track_info_id"], name: "index_tracks_on_track_info_id"
  end

  add_foreign_key "events", "tracks"
  add_foreign_key "tracks", "stations"
end

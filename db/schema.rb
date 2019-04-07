# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_07_185037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "comunas", force: :cascade do |t|
    t.string "name"
    t.geography "bounds", limit: {:srid=>4326, :type=>"multi_polygon", :geographic=>true}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "station_logs", force: :cascade do |t|
    t.datetime "last_update"
    t.integer "empty_slots"
    t.integer "free_bikes"
    t.bigint "station_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_update"], name: "index_station_logs_on_last_update"
    t.index ["station_id"], name: "index_station_logs_on_station_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.string "citybikes_id"
    t.string "citybikes_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.geography "location", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.bigint "comuna_id"
    t.datetime "last_update"
    t.integer "empty_slots"
    t.integer "free_bikes"
    t.index ["comuna_id"], name: "index_stations_on_comuna_id"
  end

end

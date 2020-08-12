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

ActiveRecord::Schema.define(version: 2020_08_11_105131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_points", force: :cascade do |t|
    t.bigint "golfer_id", null: false
    t.bigint "tournament_id", null: false
    t.string "value"
    t.integer "rank"
    t.bigint "data_source_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["data_source_id"], name: "index_data_points_on_data_source_id"
    t.index ["golfer_id"], name: "index_data_points_on_golfer_id"
    t.index ["tournament_id"], name: "index_data_points_on_tournament_id"
  end

  create_table "data_sources", force: :cascade do |t|
    t.string "stat"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "pga_id"
    t.string "stat_column_name"
  end

  create_table "golfers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scrape_loggers", force: :cascade do |t|
    t.datetime "run_at", null: false
    t.integer "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.string "pga_id"
    t.integer "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "data_points", "data_sources"
  add_foreign_key "data_points", "golfers"
  add_foreign_key "data_points", "tournaments"
end

# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150626182044) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.integer  "adoption_request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["adoption_request_id"], name: "index_addresses_on_adoption_request_id", using: :btree

  create_table "adoption_requests", force: true do |t|
    t.integer  "tree_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "maintenance_records", force: true do |t|
    t.string   "status_code"
    t.string   "reason_code"
    t.string   "diameter_breast_height"
    t.integer  "planting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "maintenance_records", ["planting_id"], name: "index_maintenance_records_on_planting_id", using: :btree

  create_table "notes", force: true do |t|
    t.string   "note"
    t.integer  "user_id"
    t.integer  "planting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["planting_id"], name: "index_notes_on_planting_id", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "people", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.integer  "adoption_request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["adoption_request_id"], name: "index_people_on_adoption_request_id", using: :btree

  create_table "plantings", force: true do |t|
    t.integer  "adoption_request_id"
    t.integer  "tree_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "planted_on"
    t.string   "event"
    t.string   "placement"
    t.string   "plant_space_width"
    t.boolean  "stakes_removed"
  end

  add_index "plantings", ["adoption_request_id"], name: "index_plantings_on_adoption_request_id", using: :btree
  add_index "plantings", ["tree_id"], name: "index_plantings_on_tree_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "trees", force: true do |t|
    t.string   "common_name"
    t.string   "scientific_name"
    t.string   "family_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",                        null: false
    t.string   "email",                           null: false
    t.string   "crypted_password",                null: false
    t.string   "password_salt",                   null: false
    t.string   "persistence_token",               null: false
    t.string   "single_access_token",             null: false
    t.string   "perishable_token",                null: false
    t.integer  "login_count",         default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
  end

  add_index "users", ["last_request_at"], name: "index_users_on_last_request_at", using: :btree
  add_index "users", ["persistence_token"], name: "index_users_on_persistence_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end

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

ActiveRecord::Schema.define(version: 20141025222259) do

  create_table "events", force: true do |t|
    t.string   "ext_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "calendar_id"
    t.string   "calendar_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["calendar_id"], name: "index_events_on_calendar_id"

  create_table "google_calendars", force: true do |t|
    t.integer  "user_id"
    t.string   "ext_id"
    t.datetime "last_synced"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "google_calendars", ["user_id"], name: "index_google_calendars_on_user_id"

  create_table "meetings", force: true do |t|
    t.string   "name"
    t.string   "time_ranges"
    t.integer  "team_id"
    t.integer  "creator_id"
    t.string   "where"
    t.text     "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "length"
  end

  add_index "meetings", ["creator_id"], name: "index_meetings_on_creator_id"
  add_index "meetings", ["team_id"], name: "index_meetings_on_team_id"

  create_table "team_memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_memberships", ["team_id"], name: "index_team_memberships_on_team_id"
  add_index "team_memberships", ["user_id"], name: "index_team_memberships_on_user_id"

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "access_token"
    t.string   "authentication_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

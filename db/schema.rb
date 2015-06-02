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

ActiveRecord::Schema.define(version: 20150602122332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "build_results", force: :cascade do |t|
    t.integer  "build_id"
    t.integer  "device_id"
    t.boolean  "passed"
    t.string   "log_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "builds", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "ci_build_number"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "error"
    t.string   "status"
  end

  create_table "devices", force: :cascade do |t|
    t.string   "model"
    t.string   "version"
    t.string   "adb_device_id"
    t.integer  "project_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "ruby_version"
    t.string   "ruby_gemset"
    t.string   "build_variant"
    t.string   "git_repo"
    t.string   "git_branch"
  end

end

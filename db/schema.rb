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

ActiveRecord::Schema.define(version: 20190806151102) do

  create_table "jobs", force: :cascade do |t|
    t.string   "status"
    t.string   "script_name"
    t.string   "job_path"
    t.string   "pbsid"
    t.integer  "submission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "jobs", ["submission_id"], name: "index_jobs_on_submission_id"

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "directory"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "name"
    t.string   "frames"
    t.string   "camera"
    t.string   "renderer"
    t.string   "extra"
    t.string   "file"
    t.integer  "cores"
    t.string   "cluster"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "submissions", ["project_id"], name: "index_submissions_on_project_id"

end

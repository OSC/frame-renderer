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

ActiveRecord::Schema.define(version: 2021_09_09_190250) do

  create_table "jobs", force: :cascade do |t|
    t.string "status"
    t.string "job_id"
    t.string "cluster"
    t.integer "script_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "directory"
    t.text "job_attrs", default: ""
    t.index ["script_id"], name: "index_jobs_on_script_id"
  end

  create_table "json_stores", force: :cascade do |t|
    t.text "json_attrs"
    t.string "type"
    t.index ["type"], name: "index_json_stores_on_type"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "directory"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "project_attrs", default: ""
    t.text "type"
  end

  create_table "scripts", force: :cascade do |t|
    t.string "name"
    t.string "frames"
    t.string "camera"
    t.string "renderer"
    t.string "extra"
    t.string "file"
    t.string "cluster"
    t.integer "walltime"
    t.boolean "email"
    t.boolean "skip_existing"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nodes", default: 1
    t.text "script_attrs", default: ""
    t.string "accounting_id"
    t.text "type"
    t.string "version"
    t.index ["project_id"], name: "index_scripts_on_project_id"
  end

end

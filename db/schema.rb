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

ActiveRecord::Schema.define(version: 20170524230352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "value",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "papers", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "latest_version_id"
  end

  add_index "papers", ["latest_version_id"], name: "index_papers_on_latest_version_id", using: :btree

  create_table "versioned_answers", id: false, force: :cascade do |t|
    t.integer "version_id"
    t.integer "answer_id"
  end

  add_index "versioned_answers", ["answer_id"], name: "index_versioned_answers_on_answer_id", using: :btree
  add_index "versioned_answers", ["version_id"], name: "index_versioned_answers_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.integer  "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "paper_id"
  end

  add_index "versions", ["paper_id"], name: "index_versions_on_paper_id", using: :btree

  add_foreign_key "papers", "versions", column: "latest_version_id"
  add_foreign_key "versioned_answers", "versions"
  add_foreign_key "versions", "papers"
end

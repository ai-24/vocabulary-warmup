# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_25_142334) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarkings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "expression_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expression_id"], name: "index_bookmarkings_on_expression_id"
    t.index ["user_id"], name: "index_bookmarkings_on_user_id"
  end

  create_table "examples", force: :cascade do |t|
    t.string "content", null: false
    t.bigint "expression_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expression_item_id"], name: "index_examples_on_expression_item_id"
  end

  create_table "expression_items", force: :cascade do |t|
    t.string "content", null: false
    t.text "explanation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "expression_id"
    t.index ["expression_id"], name: "index_expression_items_on_expression_id"
  end

  create_table "expressions", force: :cascade do |t|
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memorisings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "expression_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expression_id"], name: "index_memorisings_on_expression_id"
    t.index ["user_id"], name: "index_memorisings_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "expression_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expression_id"], name: "index_taggings_on_expression_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "uid", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookmarkings", "expressions"
  add_foreign_key "bookmarkings", "users"
  add_foreign_key "examples", "expression_items"
  add_foreign_key "expression_items", "expressions"
  add_foreign_key "memorisings", "expressions"
  add_foreign_key "memorisings", "users"
  add_foreign_key "taggings", "expressions"
  add_foreign_key "taggings", "tags"
end

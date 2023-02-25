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

ActiveRecord::Schema.define(version: 2023_02_23_015218) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guests", force: :cascade do |t|
    t.string "email"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.text "phone_numbers", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_guests_on_email", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.string "code", null: false
    t.integer "guest_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "nights", null: false
    t.integer "guests", null: false
    t.integer "adults", null: false
    t.integer "children", default: 0, null: false
    t.integer "infants", default: 0, null: false
    t.string "status", null: false
    t.string "currency", null: false
    t.string "payout_price", null: false
    t.string "security_price", null: false
    t.string "total_price", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_reservations_on_code", unique: true
  end

  add_foreign_key "reservations", "guests"
end

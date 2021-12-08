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

ActiveRecord::Schema.define(version: 2021_11_27_144630) do

  create_table "cars", force: :cascade do |t|
    t.integer "seats"
    t.integer "available_seats"
    t.index ["available_seats"], name: "index_cars_on_available_seats"
  end

  create_table "groups", force: :cascade do |t|
    t.integer "people"
    t.boolean "waiting", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["waiting", "created_at"], name: "index_groups_on_waiting_and_created_at"
  end

  create_table "journeys", force: :cascade do |t|
    t.integer "car_id"
    t.integer "group_id"
  end

end

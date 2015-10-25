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

ActiveRecord::Schema.define(version: 20150920061501) do

  create_table "cars", primary_key: "license_plate_number", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "seats",          limit: 4
    t.string  "owner_username", limit: 255, null: false
  end

  add_index "cars", ["owner_username"], name: "owner_username", using: :btree

  create_table "offers", id: false, force: :cascade do |t|
    t.datetime "datetime",                                         null: false
    t.string   "pickUpPoint",              limit: 255
    t.string   "dropOffPoint",             limit: 255
    t.integer  "cost",                     limit: 4,   default: 0
    t.integer  "vacancies",                limit: 4
    t.string   "car_license_plate_number", limit: 255,             null: false
  end

  add_index "offers", ["car_license_plate_number"], name: "index_offers_on_car_license_plate_number", using: :btree

  create_table "requests", id: false, force: :cascade do |t|
    t.string   "requester_username",             limit: 255, null: false
    t.boolean  "status",                         limit: 1
    t.datetime "offer_datetime",                             null: false
    t.string   "offer_car_license_plate_number", limit: 255, null: false
  end

  add_index "requests", ["offer_car_license_plate_number"], name: "offer_car_license_plate_number", using: :btree
  add_index "requests", ["offer_datetime", "offer_car_license_plate_number"], name: "index_requests_on_offer_details", using: :btree

  create_table "users", primary_key: "username", force: :cascade do |t|
    t.boolean  "isAdmin",                limit: 1
    t.integer  "credits",                limit: 4,   default: 50
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "cars", "users", column: "owner_username", primary_key: "username", name: "cars_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "offers", "cars", column: "car_license_plate_number", primary_key: "license_plate_number", name: "offers_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "requests", "offers", column: "offer_car_license_plate_number", primary_key: "car_license_plate_number", name: "requests_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "requests", "users", column: "requester_username", primary_key: "username", name: "requests_ibfk_1", on_update: :cascade, on_delete: :cascade
end

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

ActiveRecord::Schema.define(version: 20150815180043) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.string  "title"
    t.integer "category_id"
  end

  add_index "options", ["category_id"], name: "index_options_on_category_id", using: :btree

  create_table "positions", force: :cascade do |t|
    t.boolean  "delta",                     default: true, null: false
    t.string   "status"
    t.integer  "position_id"
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "option_id"
    t.integer  "category_id"
    t.integer  "trade_type_id"
    t.integer  "currency_id"
    t.float    "price"
    t.float    "price_etalon"
    t.float    "price_discount",            default: 0.0,  null: false
    t.integer  "price_weight_dimension_id"
    t.float    "weight"
    t.float    "weight_min",                default: 0.0,  null: false
    t.float    "weight_etalon"
    t.float    "weight_min_etalon",         default: 0.0,  null: false
    t.integer  "weight_dimension_id"
    t.integer  "weight_min_dimension_id"
    t.string   "index_field"
    t.string   "city"
    t.string   "address"
    t.float    "lat"
    t.float    "lng"
    t.integer  "deal_with_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "positions", ["category_id"], name: "index_positions_on_category_id", using: :btree
  add_index "positions", ["city"], name: "index_positions_on_city", using: :btree
  add_index "positions", ["deal_with_id"], name: "index_positions_on_deal_with_id", using: :btree
  add_index "positions", ["lat"], name: "index_positions_on_lat", using: :btree
  add_index "positions", ["lng"], name: "index_positions_on_lng", using: :btree
  add_index "positions", ["option_id"], name: "index_positions_on_option_id", using: :btree
  add_index "positions", ["position_id"], name: "index_positions_on_position_id", using: :btree
  add_index "positions", ["price"], name: "index_positions_on_price", using: :btree
  add_index "positions", ["price_etalon"], name: "index_positions_on_price_etalon", using: :btree
  add_index "positions", ["trade_type_id"], name: "index_positions_on_trade_type_id", using: :btree
  add_index "positions", ["user_id"], name: "index_positions_on_user_id", using: :btree
  add_index "positions", ["weight_dimension_id"], name: "index_positions_on_weight_dimension_id", using: :btree
  add_index "positions", ["weight_etalon"], name: "index_positions_on_weight_etalon", using: :btree
  add_index "positions", ["weight_min_dimension_id"], name: "index_positions_on_weight_min_dimension_id", using: :btree
  add_index "positions", ["weight_min_etalon"], name: "index_positions_on_weight_min_etalon", using: :btree

  create_table "positions_offers", force: :cascade do |t|
    t.integer  "position_id"
    t.integer  "offer_id"
    t.string   "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "positions_offers", ["offer_id", "position_id"], name: "index_positions_offers_on_offer_id_and_position_id", using: :btree
  add_index "positions_offers", ["offer_id"], name: "index_positions_offers_on_offer_id", using: :btree
  add_index "positions_offers", ["position_id"], name: "index_positions_offers_on_position_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "fullname"
    t.string   "avatar"
    t.string   "phones",                 default: [],                array: true
    t.string   "city"
    t.string   "address"
    t.float    "lat"
    t.float    "lng"
    t.integer  "currency_id",            default: 2,    null: false
    t.string   "company"
    t.text     "additional"
    t.json     "events",                 default: {}
    t.string   "locale",                 default: "ru", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weight_dimensions", force: :cascade do |t|
    t.string   "name"
    t.float    "convert"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

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

ActiveRecord::Schema.define(version: 20150707204759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "positions", force: :cascade do |t|
    t.boolean  "delta",               default: true,  null: false
    t.string   "status"
    t.integer  "position_id"
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "option_id"
    t.string   "template"
    t.integer  "trade_type"
    t.integer  "currency_id"
    t.float    "price"
    t.float    "price_etalon"
    t.float    "price_discount",      default: 0.0,   null: false
    t.float    "weight"
    t.float    "weight_min",          default: 0.0,   null: false
    t.float    "weight_etalon"
    t.float    "weight_min_etalon",   default: 0.0,   null: false
    t.integer  "weight_dimension_id"
    t.integer  "deal_with_id"
    t.boolean  "is_offer",            default: false, null: false
    t.string   "index_field"
    t.string   "city"
    t.string   "address"
    t.float    "coords",              default: [],                 array: true
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "positions", ["city"], name: "index_positions_on_city", using: :btree
  add_index "positions", ["deal_with_id"], name: "index_positions_on_deal_with_id", using: :btree
  add_index "positions", ["is_offer"], name: "index_positions_on_is_offer", using: :btree
  add_index "positions", ["option_id"], name: "index_positions_on_option_id", using: :btree
  add_index "positions", ["position_id"], name: "index_positions_on_position_id", using: :btree
  add_index "positions", ["price_etalon"], name: "index_positions_on_price_etalon", using: :btree
  add_index "positions", ["trade_type"], name: "index_positions_on_trade_type", using: :btree
  add_index "positions", ["user_id"], name: "index_positions_on_user_id", using: :btree
  add_index "positions", ["weight_dimension_id"], name: "index_positions_on_weight_dimension_id", using: :btree
  add_index "positions", ["weight_etalon"], name: "index_positions_on_weight_etalon", using: :btree
  add_index "positions", ["weight_min_etalon"], name: "index_positions_on_weight_min_etalon", using: :btree

end

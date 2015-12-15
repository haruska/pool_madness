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

ActiveRecord::Schema.define(version: 20151210154723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bracket_points", force: :cascade do |t|
    t.integer  "bracket_id",                      null: false
    t.integer  "points",          default: 0,     null: false
    t.integer  "possible_points", default: 0,     null: false
    t.integer  "best_possible",   default: 60000
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "bracket_points", ["best_possible"], name: "index_bracket_points_on_best_possible", using: :btree
  add_index "bracket_points", ["bracket_id"], name: "index_bracket_points_on_bracket_id", unique: true, using: :btree
  add_index "bracket_points", ["points"], name: "index_bracket_points_on_points", using: :btree
  add_index "bracket_points", ["possible_points"], name: "index_bracket_points_on_possible_points", using: :btree

  create_table "brackets", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "charge_id"
    t.integer  "tie_breaker"
    t.integer  "payment_collector_id"
    t.string   "stripe_charge_id"
    t.string   "name",                                            null: false
    t.integer  "payment_state",                       default: 0
    t.integer  "pool_id",                                         null: false
    t.decimal  "tree_decisions",       precision: 20, default: 0, null: false
    t.decimal  "tree_mask",            precision: 20, default: 0, null: false
  end

  add_index "brackets", ["charge_id"], name: "index_brackets_on_stripe_charge_id", using: :btree
  add_index "brackets", ["name"], name: "index_brackets_on_name", using: :btree
  add_index "brackets", ["payment_collector_id"], name: "index_brackets_on_payment_collector_id", using: :btree
  add_index "brackets", ["pool_id", "name"], name: "index_brackets_on_pool_id_and_name", unique: true, using: :btree
  add_index "brackets", ["pool_id"], name: "index_brackets_on_pool_id", using: :btree
  add_index "brackets", ["user_id"], name: "index_brackets_on_user_id", using: :btree

  create_table "charges", force: :cascade do |t|
    t.string   "order_id"
    t.datetime "completed_at"
    t.integer  "amount"
    t.text     "transaction_hash"
    t.integer  "bracket_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "charges", ["bracket_id"], name: "index_charges_on_bracket_id", unique: true, using: :btree

  create_table "pool_users", force: :cascade do |t|
    t.integer  "pool_id",                null: false
    t.integer  "user_id",                null: false
    t.integer  "role",       default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "pool_users", ["pool_id", "user_id"], name: "index_pool_users_on_pool_id_and_user_id", unique: true, using: :btree
  add_index "pool_users", ["pool_id"], name: "index_pool_users_on_pool_id", using: :btree
  add_index "pool_users", ["role"], name: "index_pool_users_on_role", using: :btree
  add_index "pool_users", ["user_id"], name: "index_pool_users_on_user_id", using: :btree

  create_table "pools", force: :cascade do |t|
    t.integer  "tournament_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "name"
    t.string   "invite_code"
    t.integer  "entry_fee",     default: 1000, null: false
  end

  add_index "pools", ["invite_code"], name: "index_pools_on_invite_code", unique: true, using: :btree
  add_index "pools", ["tournament_id", "name"], name: "index_pools_on_tournament_id_and_name", unique: true, using: :btree
  add_index "pools", ["tournament_id"], name: "index_pools_on_tournament_id", using: :btree

  create_table "rounds", force: :cascade do |t|
    t.integer  "tournament_id", null: false
    t.string   "name",          null: false
    t.datetime "start_date",    null: false
    t.datetime "end_date",      null: false
    t.integer  "number",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "rounds", ["tournament_id", "name"], name: "index_rounds_on_tournament_id_and_name", unique: true, using: :btree
  add_index "rounds", ["tournament_id", "number"], name: "index_rounds_on_tournament_id_and_number", unique: true, using: :btree
  add_index "rounds", ["tournament_id"], name: "index_rounds_on_tournament_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",          null: false
    t.integer  "seed",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "score_team_id"
    t.string   "region"
    t.integer  "tournament_id", null: false
    t.integer  "starting_slot"
  end

  add_index "teams", ["region"], name: "index_teams_on_region", using: :btree
  add_index "teams", ["score_team_id"], name: "index_teams_on_score_team_id", using: :btree
  add_index "teams", ["seed"], name: "index_teams_on_seed", using: :btree
  add_index "teams", ["starting_slot"], name: "index_teams_on_starting_slot", using: :btree
  add_index "teams", ["tournament_id", "name"], name: "index_teams_on_tournament_id_and_name", unique: true, using: :btree
  add_index "teams", ["tournament_id", "region", "seed"], name: "index_teams_on_tournament_id_and_region_and_seed", unique: true, using: :btree
  add_index "teams", ["tournament_id", "starting_slot"], name: "index_teams_on_tournament_id_and_starting_slot", unique: true, using: :btree
  add_index "teams", ["tournament_id"], name: "index_teams_on_tournament_id", using: :btree

  create_table "tournaments", force: :cascade do |t|
    t.datetime "tip_off"
    t.integer  "eliminating_offset",                default: 345600, null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "name"
    t.integer  "num_rounds",                        default: 6,      null: false
    t.decimal  "game_decisions",     precision: 20, default: 0,      null: false
    t.decimal  "game_mask",          precision: 20, default: 0,      null: false
  end

  add_index "tournaments", ["name"], name: "index_tournaments_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "invitation_token",       limit: 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "stripe_customer_id"
    t.integer  "role",                              default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

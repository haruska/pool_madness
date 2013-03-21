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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130320212905) do

  create_table "brackets", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "charge_id"
    t.integer  "tie_breaker"
    t.string   "payment_state",        :default => "unpaid", :null => false
    t.integer  "payment_collector_id"
    t.string   "stripe_charge_id"
    t.string   "name"
    t.integer  "points",               :default => 0,        :null => false
    t.integer  "possible_points",      :default => 0,        :null => false
  end

  add_index "brackets", ["charge_id"], :name => "index_brackets_on_stripe_charge_id"
  add_index "brackets", ["payment_collector_id"], :name => "index_brackets_on_payment_collector_id"
  add_index "brackets", ["payment_state"], :name => "index_brackets_on_payment_state"
  add_index "brackets", ["points"], :name => "index_brackets_on_points"
  add_index "brackets", ["possible_points"], :name => "index_brackets_on_possible_points"
  add_index "brackets", ["user_id"], :name => "index_brackets_on_user_id"

  create_table "charges", :force => true do |t|
    t.string   "order_id"
    t.datetime "completed_at"
    t.integer  "amount"
    t.text     "transaction_hash"
    t.integer  "bracket_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "charges", ["bracket_id"], :name => "index_charges_on_bracket_id", :unique => true

  create_table "games", :force => true do |t|
    t.integer  "team_one_id"
    t.integer  "team_two_id"
    t.integer  "game_one_id"
    t.integer  "game_two_id"
    t.integer  "score_one"
    t.integer  "score_two"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "games", ["game_one_id"], :name => "index_games_on_game_one_id"
  add_index "games", ["game_two_id"], :name => "index_games_on_game_two_id"
  add_index "games", ["team_one_id"], :name => "index_games_on_team_one_id"
  add_index "games", ["team_two_id"], :name => "index_games_on_team_two_id"

  create_table "picks", :force => true do |t|
    t.integer  "bracket_id", :null => false
    t.integer  "game_id",    :null => false
    t.integer  "team_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "picks", ["bracket_id", "game_id"], :name => "index_picks_on_bracket_id_and_game_id", :unique => true
  add_index "picks", ["bracket_id"], :name => "index_picks_on_bracket_id"
  add_index "picks", ["game_id"], :name => "index_picks_on_game_id"
  add_index "picks", ["team_id"], :name => "index_picks_on_team_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"
  add_index "roles", ["resource_id"], :name => "index_roles_on_resource_id"
  add_index "roles", ["resource_type"], :name => "index_roles_on_resource_type"

  create_table "teams", :force => true do |t|
    t.string   "name",          :null => false
    t.integer  "seed",          :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "score_team_id"
    t.string   "region"
  end

  add_index "teams", ["name"], :name => "index_teams_on_name", :unique => true
  add_index "teams", ["region", "seed"], :name => "index_teams_on_region_and_seed", :unique => true
  add_index "teams", ["region"], :name => "index_teams_on_region"
  add_index "teams", ["score_team_id"], :name => "index_teams_on_score_team_id", :unique => true
  add_index "teams", ["seed"], :name => "index_teams_on_seed"

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "stripe_customer_id"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end

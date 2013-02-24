class CreatePicks < ActiveRecord::Migration
  def change
    create_table "picks", :force => true do |t|
      t.integer  "bracket_id", :null => false
      t.integer  "game_id",    :null => false
      t.integer  "team_id"
      t.timestamps
    end

    add_index "picks", ["bracket_id", "game_id"], :unique => true
    add_index "picks", "bracket_id"
    add_index "picks", "game_id"
    add_index "picks", "team_id"
  end
end

class DropPossible < ActiveRecord::Migration
  def change
    drop_table :possible_outcomes
    drop_table :possible_games
  end
end

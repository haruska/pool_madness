class CreatePossibleGames < ActiveRecord::Migration
  def change
    create_table :possible_games do |t|
      t.integer :possible_outcome_id, :null => false
      t.integer :game_id, :null => false
      t.integer :game_one_id
      t.integer :game_two_id
      t.integer :score_one, :null => false
      t.integer :score_two, :null => false
      t.timestamps
    end

    add_index :possible_games, :possible_outcome_id
    add_index :possible_games, :game_id
    add_index :possible_games, [:possible_outcome_id, :game_id], :unique => true
  end
end

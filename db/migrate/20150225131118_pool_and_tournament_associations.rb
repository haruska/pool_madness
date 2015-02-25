class PoolAndTournamentAssociations < ActiveRecord::Migration
  def change
    add_column :brackets, :pool_id, :integer, null: false
    add_index :brackets, :pool_id
    add_column :games, :tournament_id, :integer, null: false
    add_index :games, :tournament_id

    #until we breakout participants
    add_column :teams, :tournament_id, :integer, null: false
    add_index :teams, :tournament_id

    remove_index :teams, :name
    remove_index :teams, [:region, :seed]
    remove_index :teams, :score_team_id

    add_index :teams, [:tournament_id, :name], unique: true
    add_index :teams, [:tournament_id, :region, :seed], unique: true
    add_index :teams, :score_team_id
  end
end

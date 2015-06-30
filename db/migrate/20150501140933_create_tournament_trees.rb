class CreateTournamentTrees < ActiveRecord::Migration
  def change
    add_column :brackets, :tree_decisions, :decimal, precision: 20, scale: 0, default: 0, null: false
    add_column :brackets, :tree_mask, :decimal, precision: 20, scale: 0, default: 0, null: false

    add_column :tournaments, :game_decisions, :decimal, precision: 20, scale: 0, default: 0, null: false
    add_column :tournaments, :game_mask, :decimal, precision: 20, scale: 0, default: 0, null: false
  end
end

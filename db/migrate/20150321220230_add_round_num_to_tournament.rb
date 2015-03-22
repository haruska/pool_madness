class AddRoundNumToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :num_rounds, :integer, default: 6, null: false
  end
end

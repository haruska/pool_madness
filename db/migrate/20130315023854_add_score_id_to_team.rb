class AddScoreIdToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :score_team_id, :integer
    add_index :teams, :score_team_id, unique: true
  end
end

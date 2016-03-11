class ScoreTeamIdIntToStr < ActiveRecord::Migration
  def change
    change_column :teams, :score_team_id, :string
  end
end

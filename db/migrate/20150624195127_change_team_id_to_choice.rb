class ChangeTeamIdToChoice < ActiveRecord::Migration
  def change
    Pick.where.not(team_id: nil).each do |pick|
      if pick.team_id == first_team_id(pick)
        pick.update(choice: 0)
      elsif pick.team_id == second_team_id(pick)
        pick.update(choice: 1)
      end
    end

    remove_column :picks, :team_id
  end

  def first_team_id(pick)
    game = pick.game
    if game.game_one.present?
      pick.bracket.picks.find_by(game_id: game.game_one_id).try(:team_id)
    else
      game.team_one_id
    end
  end

  def second_team_id(pick)
    game = pick.game
    if game.game_two.present?
      pick.bracket.picks.find_by(game_id: game.game_two_id).try(:team_id)
    else
      game.team_two_id
    end
  end
end

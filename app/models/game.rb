class Game < ActiveRecord::Base
  belongs_to :tournament

  belongs_to :team_one, class_name: Team
  belongs_to :team_two, class_name: Team
  belongs_to :game_one, class_name: Game
  belongs_to :game_two, class_name: Game

  scope :already_played, -> { where.not(score_one: nil).order(:id) }
  scope :not_played, -> { where(score_one: nil).order(:id) }

  def first_team
    team_one || game_one.winner
  end

  def second_team
    team_two || game_two.winner
  end

  def winner
    return nil if score_one.nil? || score_two.nil?
    score_one > score_two ? first_team : second_team
  end

  def next_game
    tournament.games.where(game_one_id: id).first || tournament.games.where(game_two_id: id).first
  end

  # returns 1, 2 or nil
  def next_slot
    [0, next_game.try(:game_one_id), next_game.try(:game_two_id)].index(id)
  end

  def round
    round = tournament.num_rounds # championship
    n = next_game
    while n.present?
      round -= 1
      n = n.next_game
    end
    round
  end

  def championship?
    next_slot.nil?
  end
end

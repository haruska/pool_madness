class Tournament < ActiveRecord::Base
  has_many :games, dependent: :destroy
  has_many :pools, dependent: :destroy
  has_many :teams, dependent: :destroy

  accepts_nested_attributes_for :teams

  validates :name, presence: true, uniqueness: true

  def started?
    DateTime.now > tip_off
  end

  def start_eliminating?
    num_games_remaining < 16
  end

  def championship
    tree.championship
  end

  def num_games
    2**num_rounds - 1
  end

  def num_games_played
    game_mask.to_s(2).count("1")
  end

  def num_games_remaining
    num_games - num_games_played
  end

  def round_for(round_number, region = nil)
    games = tree.round_for(round_number)

    if region.present? && games.size > Team::REGIONS.size
      slice_size = games.size / Team::REGIONS.size
      slice_index = Team::REGIONS.index(region)
      slices = games.each_slice(slice_size).to_a
      slices[slice_index]
    else
      games
    end
  end

  def tree
    TournamentTree.unmarshal(self, game_decisions, game_mask)
  end

  def update_game(position, choice)
    working_tree = tree
    working_tree.update_game(position, choice)

    marshalled_tree = working_tree.marshal
    self.game_decisions = marshalled_tree.decisions
    self.game_mask = marshalled_tree.mask
  end
end

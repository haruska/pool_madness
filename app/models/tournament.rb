class Tournament < ActiveRecord::Base
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

  def game_ids_for(round_number, region = nil)
    game_ids = tree.game_ids_for(round_number)

    if region.present? && game_ids.size >= Team::REGIONS.size
      slice_size = game_ids.size / Team::REGIONS.size
      slice_index = Team::REGIONS.index(region)
      slices = game_ids.each_slice(slice_size).to_a
      slices[slice_index]
    else
      game_ids
    end
  end

  def round_for(round_number, region = nil)
    tree.select_games(game_ids_for(round_number, region))
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

  def update_game!(position, choice)
    update_game(position, choice)
    save!
  end

  def games_hash
    working_tree = tree
    (1..num_games).map do |game_id|
      node = working_tree.at(game_id)
      {
          id: game_id,
          teamOne: team_hash(node.team_one),
          teamTwo: team_hash(node.team_two),
          winningTeam: team_hash(node.team),
          gameOneId: node.left_position,
          gameTwoId: node.right_position,
          nextGameId: node.next_game_slot,
          nextSlot: node.next_slot,
          choice: node.decision
      }
    end
  end

  private

  def team_hash(team)
    team.present? ? { id: team.id, seed: team.seed, name: team.name } : nil
  end
end

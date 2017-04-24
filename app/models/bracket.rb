class Bracket < ApplicationRecord
  belongs_to :pool
  belongs_to :user
  belongs_to :payment_collector, class_name: "User", optional: true

  has_one :charge
  has_one :tournament, through: :pool
  has_one :bracket_point, dependent: :destroy

  delegate :points, :possible_points, :best_possible, :calculate_possible_points, :calculate_points, to: :bracket_point

  after_create :create_bracket_point

  after_save do |bracket|
    BracketScoreJob.perform_later(bracket.id)
  end

  before_validation do |bracket|
    bracket.tie_breaker = nil if bracket.tie_breaker.to_i <= 0
    bracket.name = bracket.default_name if bracket.name.blank? && bracket.user.present? && bracket.pool.present?
  end

  validates :name, uniqueness: { scope: :pool_id }, presence: true
  validates :user, :tie_breaker, :pool, :user, presence: true
  validate :filled_out

  enum payment_state: %i[unpaid promised paid]

  def status
    unpaid? ? :unpaid : :ok
  end

  def only_bracket_for_user?
    user.brackets.size == 1
  end

  def default_name
    default_name = user.name
    i = 1
    while pool.brackets.find_by(name: default_name).present?
      default_name = "#{user.name} #{i}"
      i += 1
    end
    default_name
  end

  def complete?
    tree.complete? && tie_breaker.present?
  end

  def incomplete?
    !complete?
  end

  def sorted_four
    cache_key = "bracket-#{id}-sortedfour-#{updated_at.to_i}"
    Rails.cache.fetch(cache_key) do
      working_tree = tree
      slot_count = 2**3 - 1
      values = (1..slot_count).map { |slot| working_tree.at(slot).value }.uniq.compact

      tournament.teams.where(starting_slot: values).sort_by { |x| values.index(x.starting_slot) * -1 }
    end
  end

  def tree
    working_tree = TournamentTree.unmarshal(tournament, tree_decisions, tree_mask)
    (1..tournament.num_games).map { |slot| working_tree.at(slot).bracket = self }
    working_tree
  end

  def update_choice(position, choice)
    working_tree = tree
    working_tree.update_game(position, choice)

    marshalled_tree = working_tree.marshal
    self.tree_decisions = marshalled_tree.decisions
    self.tree_mask = marshalled_tree.mask
  end

  def update_choice!(position, choice)
    update_choice(position, choice)
    save!
  end

  def picks
    working_tree = tree
    (1..tournament.num_games).map { |slot| working_tree.at(slot) }
  end

  def games_hash
    working_tree = tree
    games_hash = tournament.games_hash
    games_hash.each do |game_hash|
      game_hash[:choice] = working_tree.at(game_hash[:slot]).decision
    end
    games_hash
  end

  protected

  def filled_out
    errors.add(:base, "is not completed") unless tournament.present? && tree.complete?
  end
end

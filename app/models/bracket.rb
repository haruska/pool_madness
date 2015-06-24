class Bracket < ActiveRecord::Base
  belongs_to :pool
  belongs_to :user
  belongs_to :payment_collector, class_name: "User"

  has_one :charge
  has_one :tournament, through: :pool
  has_one :bracket_point, dependent: :destroy

  has_many :picks, dependent: :destroy

  delegate :points, :possible_points, :best_possible, :calculate_possible_points, :calculate_points, to: :bracket_point

  after_create :create_all_picks
  after_create :create_bracket_point

  before_validation do |bracket|
    bracket.tie_breaker = nil if bracket.tie_breaker.to_i <= 0
    bracket.name = bracket.default_name if bracket.name.blank?
  end

  validates :name, uniqueness: { scope: :pool_id }, presence: true
  validates :user, presence: true

  enum payment_state: %i(unpaid promised paid)

  def status
    if self.incomplete?
      :incomplete
    elsif self.unpaid?
      :unpaid
    else
      :ok
    end
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
    picks.where(choice: -1).first.blank? && tie_breaker.present?
  end

  def incomplete?
    !complete?
  end

  def sorted_four
    champ_pick = picks.where(game_id: tournament.championship.id).first
    four = [champ_pick.team, champ_pick.first_team, champ_pick.second_team]
    four << picks.where(game_id: champ_pick.game.game_one_id).first.first_team
    four << picks.where(game_id: champ_pick.game.game_one_id).first.second_team
    four << picks.where(game_id: champ_pick.game.game_two_id).first.first_team
    four << picks.where(game_id: champ_pick.game.game_two_id).first.second_team

    team_ids = four.compact.uniq.reverse.collect(&:id)

    Team.where(id: team_ids).to_a.sort_by { |x| team_ids.index(x.id) }
  end

  private

  def create_all_picks
    tournament.games.all.each { |game| picks.create(game_id: game.id) }
  end
end

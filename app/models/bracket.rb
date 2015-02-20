class Bracket < ActiveRecord::Base
  has_many :picks, dependent: :destroy
  has_one :charge

  belongs_to :user
  belongs_to :payment_collector, class_name: "User"

  after_create :create_all_picks

  before_validation do |bracket|
    bracket.tie_breaker = nil if bracket.tie_breaker.to_i <= 0
    bracket.name = bracket.default_name if bracket.name.blank?
  end

  validates :name, uniqueness: true, presence: true
  validates :user, presence: true

  state_machine :payment_state, initial: :unpaid do
    state :unpaid
    state :promised
    state :paid

    event :promise_made do
      transition unpaid: :promised
    end

    event :payment_received do
      transition all => :paid
    end
  end

  def status
    if !self.complete?
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
    while Bracket.find_by(name: default_name).present?
      default_name = "#{user.name} #{i}"
      i += 1
    end
    default_name
  end

  def complete?
    picks.where(team_id: nil).first.blank? && picks.where(team_id: -1).first.blank? && tie_breaker.present?
  end

  def incomplete?
    !complete?
  end

  def calculate_possible_points
    points_calc = picks.collect(&:possible_points).sum
    update_attribute(:possible_points, points_calc)
    points_calc
  end

  def calculate_points
    points_calc = picks.collect(&:points).sum
    update_attribute(:points, points_calc)
    points_calc
  end

  def sorted_four
    team_ids = Rails.cache.fetch("sorted_four_#{id}") do
      champ_pick = picks.where(game_id: Game.championship.id).first
      four = [champ_pick.team, champ_pick.first_team, champ_pick.second_team]
      four << picks.where(game_id: champ_pick.game.game_one_id).first.first_team
      four << picks.where(game_id: champ_pick.game.game_one_id).first.second_team
      four << picks.where(game_id: champ_pick.game.game_two_id).first.first_team
      four << picks.where(game_id: champ_pick.game.game_two_id).first.second_team

      four.compact.uniq.reverse.collect(&:id)
    end

    Team.where(id: team_ids).to_a.sort_by { |x| team_ids.index(x.id) }
  end

  private

  def create_all_picks
    Game.all.each { |game| picks.create(game_id: game.id) }
  end
end

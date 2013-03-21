class Bracket < ActiveRecord::Base
  has_many :picks, :dependent => :destroy
  has_one  :charge

  belongs_to :user
  belongs_to :payment_collector, :class_name => 'User'

  after_create :create_all_picks

  attr_accessible :tie_breaker, :name, :points, :possible_points

  before_validation do |bracket|
    bracket.tie_breaker = nil if bracket.tie_breaker.to_i <= 0
    bracket.name = bracket.default_name if bracket.name.blank?
  end

  validates :name, :uniqueness => true, :presence => true

  state_machine :payment_state, :initial => :unpaid do
    state :unpaid
    state :promised
    state :pending
    state :paid

    event :promise_made do
      transition :unpaid => :promised
    end

    event :bitcoin_payment_submited do
      transition [:unpaid, :promised] => :pending
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
    self.user.brackets.size == 1
  end

  def default_name
    default_name = self.user.name
    i = 1
    while Bracket.find_by_name(default_name).present?
      default_name = "#{self.user.name} #{i}"
      i += 1
    end
    default_name
  end

  def complete?
    self.picks.where(:team_id => nil).first.blank? && self.picks.where(:team_id => -1).first.blank? && self.tie_breaker.present?
  end

  def incomplete?
    !complete?
  end

  def calculate_possible_points
    self.update_attribute(:possible_points, self.picks.collect(&:possible_points).sum)
  end

  def calculate_points
    self.update_attribute(:points, self.picks.collect(&:points).sum)
  end

  def sorted_four
    champ_pick = self.picks.where(:game_id => Game.championship.id).first
    four = [champ_pick.team, champ_pick.first_team, champ_pick.second_team]
    four << self.picks.where(:game_id => champ_pick.game.game_one_id).first.first_team
    four << self.picks.where(:game_id => champ_pick.game.game_one_id).first.second_team
    four << self.picks.where(:game_id => champ_pick.game.game_two_id).first.first_team
    four << self.picks.where(:game_id => champ_pick.game.game_two_id).first.second_team

    four.compact.uniq.reverse
  end

  private

  def create_all_picks
    Game.all.each { |game| self.picks.create(:game_id => game.id) }
  end
end

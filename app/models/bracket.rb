class Bracket < ActiveRecord::Base
  has_many :picks, :dependent => :destroy
  belongs_to :user

  after_create :create_all_picks

  scope :paid, where("stripe_charge_id is not NULL")

  attr_accessible :tie_breaker

  def only_bracket_for_user?
    self.user.brackets.size == 1
  end

  def name
    self.only_bracket_for_user? ? self.user.name : "#{self.user.name} #{self.user.brackets.collect(&:id).index(self.id) + 1}"
  end

  def paid?
    self.stripe_charge_id.present?
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

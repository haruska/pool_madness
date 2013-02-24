class Bracket < ActiveRecord::Base
  has_many :picks, :dependent => :destroy
  belongs_to :user

  after_create :create_all_picks

  def only_bracket_for_user?
    self.user.brackets.size == 1
  end

  def name
    self.only_bracket_for_user? ? self.user.name : "#{self.user.name} #{self.user.brackets.collect(&:id).index(self.id) + 1}"
  end

  private

  def create_all_picks
    Game.all.each { |game| self.picks.create(:game_id => game.id) }
  end
end

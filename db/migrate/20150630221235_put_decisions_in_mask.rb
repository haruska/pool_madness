class PutDecisionsInMask < ActiveRecord::Migration
  def up
    Bracket.all.each do |bracket|
      bracket.picks.each { |pick| bracket.update_choice(pick.game.slot, pick.choice) }
      bracket.save!
    end
  end
end

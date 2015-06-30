class AddSlotToGame < ActiveRecord::Migration
  def change
    add_column :games, :slot, :integer
    add_index :games, :slot
    add_index :games, [:tournament_id, :slot], unique: true

    Team.all.each do |team|
      next unless team.starting_slot.even?
      slot = team.starting_slot / 2
      game = first_game_for_team(team)
      while slot > 1
        game.update(slot: slot)
        game = game.next_game
        slot /= 2
      end
    end

    Tournament.all.each do |tournament|
      tournament.championship.update(slot: 1)
    end
  end

  def first_game_for_team(team)
    team.tournament.games.find_by(team_one_id: team.id) || team.tournament.games.find_by(team_two_id: team.id)
  end
end

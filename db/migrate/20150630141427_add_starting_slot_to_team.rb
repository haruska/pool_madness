class AddStartingSlotToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :starting_slot, :integer
    add_index :teams, :starting_slot
    add_index :teams, [:tournament_id, :starting_slot], unique: true


    sort_order = [1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15]
    regions = ["South", "West", "East", "Midwest"]

    starting_slot = 64

    regions.each do |region|
      sort_order.each do |seed|
        Tournament.all.each do |tournament|
          team = Team.find_by(region: region, seed: seed, tournament_id: tournament.id)
          team.update(starting_slot: starting_slot)
        end
        starting_slot += 1
      end
    end
  end
end

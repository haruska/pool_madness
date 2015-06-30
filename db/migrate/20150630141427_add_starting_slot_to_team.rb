class AddStartingSlotToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :starting_slot, :integer
    add_index :teams, :starting_slot
    add_index :teams, [:tournament_id, :starting_slot], unique: true


    sort_order = [1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15]
    regions = ["South", "West", "East", "Midwest"]

    Tournament.all.each do |tournament|
      starting_slot = tournament.num_rounds == 6 ? 64 : 16
      regions.each do |region|
        sort_order.each do |seed|
          team = Team.find_by(region: region, seed: seed, tournament_id: tournament.id)
          if team.present?
            team.update(starting_slot: starting_slot)
            starting_slot += 1
          end
        end
      end
    end
  end
end

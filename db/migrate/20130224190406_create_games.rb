class CreateGames < ActiveRecord::Migration
  def change
    ids = %w[team_one_id team_two_id game_one_id game_two_id]

    create_table :games do |t|
      ids.each { |id| t.integer id }
      t.integer  "score_one"
      t.integer  "score_two"
      t.timestamps
    end

    ids.each {|id| add_index :games, id}
  end
end

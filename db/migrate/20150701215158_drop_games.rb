class DropGames < ActiveRecord::Migration
  def change
    drop_table :games
  end
end

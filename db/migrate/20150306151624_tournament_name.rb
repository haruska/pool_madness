class TournamentName < ActiveRecord::Migration
  def change
    add_column :tournaments, :name, :string
    add_index :tournaments, :name, unique: true
  end
end

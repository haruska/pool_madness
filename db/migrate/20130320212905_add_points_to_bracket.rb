class AddPointsToBracket < ActiveRecord::Migration
  def change
    add_column :brackets, :points, :integer, :null => false, :default => 0
    add_column :brackets, :possible_points, :integer, :null => false, :default => 0

    add_index :brackets, :points
    add_index :brackets, :possible_points
  end
end

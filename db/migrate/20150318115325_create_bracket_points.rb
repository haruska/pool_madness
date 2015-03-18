class CreateBracketPoints < ActiveRecord::Migration
  def change
    create_table :bracket_points do |t|
      t.integer :bracket_id, null: false
      t.integer :points, default: 0, null: false
      t.integer :possible_points, default: 0, null: false
      t.integer :best_possible, default: 60000
      t.timestamps null: false
    end

    add_index :bracket_points, :bracket_id, unique: true

    [:points, :possible_points, :best_possible].each do |col|
      add_index :bracket_points, col
      remove_column :brackets, col
    end
  end
end

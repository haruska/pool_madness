class AddRegion < ActiveRecord::Migration
  def up
    add_column :teams, :region, :string
    add_index :teams, :region

    remove_index :teams, [:region, :seed]
    add_index :teams, [:region, :seed], unique: true
    add_index :teams, :seed
  end

  def down
    remove_column :teams, :region
  end
end

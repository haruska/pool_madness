class DropRegion < ActiveRecord::Migration
  def up
    remove_column :teams, :region
  end

  def down
  end
end

class RolesIndexes < ActiveRecord::Migration
  def up
    add_index :roles, :resource_id
    add_index :roles, :resource_type
  end

  def down
  end
end

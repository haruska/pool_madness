class RemoveRoles < ActiveRecord::Migration
  def change
    drop_table :roles
    drop_table :users_roles

    add_column :users, :role, :integer, default: 0
  end
end

class PoolNameAndInviteCode < ActiveRecord::Migration
  def change
    add_column :pools, :name, :string
    add_column :pools, :invite_code, :string

    add_index :pools, :invite_code, unique: true
    add_index :pools, [:tournament_id, :name], unique: true
  end
end

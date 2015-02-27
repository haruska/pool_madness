class CreatePoolUsers < ActiveRecord::Migration
  def change
    create_table :pool_users do |t|
      t.integer :pool_id, null: false
      t.integer :user_id, null: false
      t.integer :role, default: 0
      t.timestamps null: false
    end

    add_index :pool_users, :pool_id
    add_index :pool_users, :user_id
    add_index :pool_users, :role
    add_index :pool_users, [:pool_id, :user_id], unique: true
  end
end

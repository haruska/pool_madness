class StripeCustomerId < ActiveRecord::Migration
  def up
    add_column :users, :stripe_customer_id, :string
    add_column :brackets, :stripe_charge_id, :string

    add_index :brackets, :stripe_charge_id
  end

  def down
    remove_column :brackets, :stripe_charge_id
    remove_column :users, :stripe_customer_id
  end
end

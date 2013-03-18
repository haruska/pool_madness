class AddStripeColumn < ActiveRecord::Migration
  def up
    add_column :brackets, :stripe_charge_id, :string
  end

  def down
  end
end

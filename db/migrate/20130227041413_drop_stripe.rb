class DropStripe < ActiveRecord::Migration
  def up
    rename_column :brackets, :stripe_charge_id, :charge_id
  end

  def down
    rename_column :brackets, :charge_id, :stripe_charge_id
  end
end

class PendingPayment < ActiveRecord::Migration
  def up
    add_column :brackets, :pending_payment, :boolean, default: false, null: false
  end

  def down
    remove_column :brackets, :pending_payment
  end
end

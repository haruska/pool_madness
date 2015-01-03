class PaymentState < ActiveRecord::Migration
  def up
    add_column :brackets, :payment_state, :string, null: false, default: 'unpaid'
    add_index :brackets, :payment_state

    add_column :brackets, :payment_collector_id, :integer
    add_index :brackets, :payment_collector_id

    remove_column :brackets, :pending_payment
  end
end

class PaymentStateToEnum < ActiveRecord::Migration
  def change
    remove_column :brackets, :payment_state
    add_column :brackets, :payment_state, :integer, default: 0
  end
end

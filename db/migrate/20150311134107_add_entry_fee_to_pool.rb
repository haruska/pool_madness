class AddEntryFeeToPool < ActiveRecord::Migration
  def change
    add_column :pools, :entry_fee, :integer, default: 1000, null: false
  end
end

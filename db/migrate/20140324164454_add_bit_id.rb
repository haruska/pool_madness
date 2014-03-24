class AddBitId < ActiveRecord::Migration
  def change
    add_column :possible_outcomes, :slot_bits, :bigint, :null => false
    add_index :possible_outcomes, :slot_bits, :unique => true
  end
end

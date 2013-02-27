class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :order_id
      t.datetime :completed_at
      t.integer :amount
      t.text :transaction_hash
      t.integer :bracket_id

      t.timestamps
    end

    add_index :charges, :bracket_id, :unique => true
  end
end

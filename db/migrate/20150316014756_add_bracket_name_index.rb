class AddBracketNameIndex < ActiveRecord::Migration
  def change
    change_column :brackets, :name, :string, null: false
    add_index :brackets, [:pool_id, :name], unique: true
    add_index :brackets, :name
  end
end

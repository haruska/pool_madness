class AddChoiceToPick < ActiveRecord::Migration
  def change
    add_column :picks, :choice, :integer, default: -1, null: false
  end
end

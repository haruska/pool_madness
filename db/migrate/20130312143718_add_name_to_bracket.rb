class AddNameToBracket < ActiveRecord::Migration
  def up
    add_column :brackets, :name, :string

    Bracket.all.each do |bracket|
      bracket.name = bracket.default_name
      bracket.save!
    end
  end

  def down
    remove_column :brackets, :name
  end
end

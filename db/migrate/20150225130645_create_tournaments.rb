class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.datetime :tip_off
      t.integer :eliminating_offset
      t.timestamps null: false
    end
  end
end

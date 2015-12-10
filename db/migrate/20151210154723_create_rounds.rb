class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :tournament_id, null: false
      t.string :name, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.integer :number, null: false
      t.timestamps null: false
    end

    add_index :rounds, :tournament_id
    add_index :rounds, [:tournament_id, :name], unique: true
    add_index :rounds, [:tournament_id, :number], unique: true
  end
end

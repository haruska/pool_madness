class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string 'name',       null: false
      t.integer 'seed',       null: false
      t.string 'region',     null: false
      t.timestamps
    end
    add_index 'teams', ['name'], unique: true
    add_index 'teams', %w(region seed), unique: true
  end
end

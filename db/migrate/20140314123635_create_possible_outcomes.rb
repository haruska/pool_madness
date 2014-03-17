class CreatePossibleOutcomes < ActiveRecord::Migration
  def change
    create_table :possible_outcomes do |t|
      t.timestamps
    end
  end
end

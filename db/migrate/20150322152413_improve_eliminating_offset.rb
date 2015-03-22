class ImproveEliminatingOffset < ActiveRecord::Migration
  def change
    change_column :tournaments, :eliminating_offset, :integer, null: false, default: 4.days
  end
end

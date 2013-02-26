class TieBreakerScore < ActiveRecord::Migration
  def up
    add_column :brackets, :tie_breaker, :integer
  end

  def down
    remove_column :brackets, :tie_breaker
  end
end

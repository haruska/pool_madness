class Charge < ActiveRecord::Base
  attr_accessible :amount, :bracket_id, :completed_at, :order_id, :transaction_hash

  belongs_to :bracket
end

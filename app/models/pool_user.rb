class PoolUser < ActiveRecord::Base
  belongs_to :pool
  belongs_to :user

  validates :user, presence: true, uniqueness: { scope: :pool_id }
  validates :pool, presence: true

  enum role: %i(regular admin)
end

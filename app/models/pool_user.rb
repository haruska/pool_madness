class PoolUser < ActiveRecord::Base
  belongs_to :pool, inverse_of: :pool_users
  belongs_to :user, inverse_of: :pool_users

  validates :user, presence: true, uniqueness: { scope: :pool_id }
  validates :pool, presence: true

  enum role: %i[regular admin]
end

class Round < ActiveRecord::Base
  belongs_to :tournament

  validates :tournament, presence: true
  validates :name, presence: true, uniqueness: { scope: :tournament_id }
  validates :number, presence: true, uniqueness: { scope: :tournament_id }
  validates :start_date, presence: true
  validates :end_date, presence: true
end

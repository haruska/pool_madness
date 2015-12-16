class Round < ActiveRecord::Base
  belongs_to :tournament

  validates :tournament, presence: true
  validates :name, presence: true, uniqueness: { scope: :tournament_id }
  validates :number, presence: true, uniqueness: { scope: :tournament_id }
  validates :start_date, presence: true
  validates :end_date, presence: true

  def date_range_string
    date_range_string = start_date.strftime("%B %e")
    date_range_string += "-#{end_date.strftime('%e')}" if start_date != end_date

    date_range_string
  end
end

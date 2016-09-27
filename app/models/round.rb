class Round
  include ActiveAttr::Model

  NAMES = ["1st Round", "2nd Round", "Sweet 16", "Elite Eight", "Final Four", "Champion"].freeze

  attribute :tournament
  attribute :number, type: Integer

  validates :tournament, :number, presence: true

  def self.find(graph_id)
    tournament_id, round_number = graph_id.split("~").map(&:to_i)
    new(tournament: Tournament.find(tournament_id), number: round_number)
  end

  def id
    "#{tournament.id}~#{number}"
  end

  def name
    names = NAMES.last(tournament.num_rounds)
    names[number - 1]
  end

  def start_date
    start_date_for(number)
  end

  def end_date
    if NAMES.last(2).include?(name)
      start_date
    else
      start_date + 1.day
    end
  end

  def games
    tournament.round_for(number)
  end

  private

  def start_date_for(round_number)
    case round_number
    when 1
      tournament.tip_off.to_date
    when 2, 4, 6
      start_date_for(round_number - 1) + 2.days
    else
      day = start_date_for(round_number - 1) + 5.days
      day += tournament.num_rounds > 4 ? (round_number - 3).days : (round_number - 1).days
      day
    end
  end
end

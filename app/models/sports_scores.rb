class SportsScores
  include ActiveAttr::Model

  attribute :date
  attribute :api_response
  attribute :changed_games, default: false

  class ScoreTeam
    include ActiveAttr::Model

    attribute :name
    attribute :seed
    attribute :score_id
  end

  def self.generate_for(date)
    new(date: date, api_response: ESPN::Score.find(ESPN::NCB, date))
  end

  def self.list_teams(dates)
    score_teams = []

    dates.each do |date|
      ESPN::Score.find(ESPN::NCB, date).each do |game|
        %w(home_team away_team).each do |team|
          score_teams << ScoreTeam.new(name: game["#{team}_name".to_sym], seed: game["#{team}_rank".to_sym].to_i, score_id: game[team.to_sym])
        end
      end
    end

    score_teams.sort_by!(&:seed)

    score_teams.each do |score_team|
      puts "##{score_team.seed} #{score_team.name} (#{score_team.score_id})"
    end
  end

  def update_scores
    api_response.select { |g| g[:state] == "postgame" }.each do |espn_game|
      Tournament.all.each do |tournament|
        home_team = tournament.teams.find_by score_team_id: espn_game[:home_team]
        away_team = tournament.teams.find_by score_team_id: espn_game[:away_team]

        game = tournament.games.to_a.find do |g|
          g.first_team == home_team && g.second_team == away_team || g.first_team == away_team && g.second_team == home_team
        end

        if game.present? && game.score_one.blank?
          if game.first_team == home_team
            game.update!(score_one: espn_game[:home_score], score_two: espn_game[:away_score])
          else
            game.update!(score_one: espn_game[:away_score], score_two: espn_game[:home_score])
          end

          game.next_game.try(:touch)

          self.changed_games = true
        end
      end
    end
  end

  def next_poll_time
    if api_response.find { |g| g[:state] == "in-progress" }.present?
      5.minutes.from_now
    elsif api_response.find { |g| g[:state] == "pregame" }.present?
      next_game = api_response.find { |g| g[:state] == "pregame" }
      time_str = "#{next_game[:game_date]} #{next_game[:start_time].gsub('ET', 'EDT')}"
      DateTime.parse(time_str)
    else
      Date.tomorrow.noon.in_time_zone("America/New_York")
    end
  end

  # ESPN::Score.find(ESPN::NCB, Date.today)
  # {
  #   :game_date=>Fri, 20 Mar 2015,
  #   :home_team=>"2305",
  #   :home_team_name=>"Kansas",
  #   :away_team=>"166",
  #   :away_team_name=>"New Mexico St",
  #   :home_score=>0,
  #   :away_score=>0,
  #   :home_team_rank=>"2",
  #   :away_team_rank=>"15",
  #   :away_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/166.png&w=200&h=200&transparent=true",
  #   :home_team_logo=>"http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/2305.png&w=200&h=200&transparent=true",
  #   :home_team_record=>"26-8",
  #   :away_team_record=>"23-10",
  #   :state=>"pregame",
  #   :start_time=>"12:15 PM ET",
  #   :preview=>"400785345",
  #   :line=>"KU -10.5 O/U 131.5",
  #   :league=>"ncb"
  # }
end

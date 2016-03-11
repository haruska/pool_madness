class SportsScores
  include ActiveAttr::Model

  attribute :date
  attribute :api_response
  attribute :changed_games, default: false

  def self.generate_for(date)
    new(date: date, api_response: ESPN.get_ncb_scores(date, nil, false))
  end

  def self.list_teams(dates)
    score_teams = {}

    dates.each do |date|
      score_teams.merge!(ESPN.get_ncb_abbreviations(date))
    end

    score_teams.keys.sort.each do |team_name|
      abbrev = score_teams[team_name]
      puts "#{team_name}: #{abbrev}"
    end

    score_teams
  end

  def update_scores
    api_response.each do |espn_game|
      next unless espn_game[:status] =~ /Final/
      Tournament.current.each do |tournament|
        home_team = tournament.teams.find_by score_team_id: espn_game[:home_team]
        away_team = tournament.teams.find_by score_team_id: espn_game[:away_team]
        winner = espn_game[:home_score] < espn_game[:away_score] ? away_team : home_team

        tree = tournament.tree
        slot = (tree.size - 1).downto(1).find do |slot|
          g = tree.at(slot)
          g.first_team == home_team && g.second_team == away_team || g.first_team == away_team && g.second_team == home_team
        end


        if slot.present?
          game = tree.at(slot)

          if game.decision.nil?
            tournament.update_game(slot, game.first_team == winner ? Game::LEFT : Game::RIGHT)
            self.changed_games = true
          end
        end
        tournament.save
      end
    end
  end

  def next_poll_time
    if started_games.present?
      5.minutes.from_now
    elsif not_started_games.present?
      not_started_games.map {|g| g[:game_date] }.sort.first
    else
      Date.tomorrow.in_time_zone("America/New_York").noon
    end
  end

  def finished_games
    api_response.select {|espn_game| espn_game[:status] =~ /Final/}
  end

  def started_games
    api_response.select {|espn_game| espn_game[:status] =~ /Half/}
  end

  def not_started_games
    api_response - finished_games - started_games
  end
end

# ESPN.get_college_basketball_scores(Date.today, nil, false)
#
# [
#     {:home_team=>"ind", :home_score=>20, :away_team=>"mich", :away_score=>23, :game_date=>Fri, 11 Mar 2016 17:00:00 +0000, :status=>"6:17 - 1st Half", :league=>"mens-college-basketball"},
#     {:home_team=>"tamu", :home_score=>0, :away_team=>"fla", :away_score=>0, :game_date=>Fri, 11 Mar 2016 18:00:00 +0000, :status=>"Fri, March 11th at 1:00 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"pur", :home_score=>0, :away_team=>"ill", :away_score=>0, :game_date=>Fri, 11 Mar 2016 19:00:00 +0000, :status=>"Fri, March 11th at 2:00 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"msu", :home_score=>0, :away_team=>"osu", :away_score=>0, :game_date=>Fri, 11 Mar 2016 23:30:00 +0000, :status=>"Fri, March 11th at 6:30 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"nova", :home_score=>0, :away_team=>"prov", :away_score=>0, :game_date=>Fri, 11 Mar 2016 23:30:00 +0000, :status=>"Fri, March 11th at 6:30 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"ku", :home_score=>0, :away_team=>"bay", :away_score=>0, :game_date=>Sat, 12 Mar 2016 00:00:00 +0000, :status=>"Fri, March 11th at 7:00 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"unc", :home_score=>0, :away_team=>"nd", :away_score=>0, :game_date=>Sat, 12 Mar 2016 00:00:00 +0000, :status=>"Fri, March 11th at 7:00 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"uk", :home_score=>0, :away_team=>"ala", :away_score=>0, :game_date=>Sat, 12 Mar 2016 00:00:00 +0000, :status=>"Fri, March 11th at 7:00 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"md", :home_score=>0, :away_team=>"neb", :away_score=>0, :game_date=>Sat, 12 Mar 2016 01:55:00 +0000, :status=>"Fri, March 11th at 8:55 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"wvu", :home_score=>0, :away_team=>"okla", :away_score=>0, :game_date=>Sat, 12 Mar 2016 02:00:00 +0000, :status=>"Fri, March 11th at 9:00 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"ore", :home_score=>0, :away_team=>"ariz", :away_score=>0, :game_date=>Sat, 12 Mar 2016 02:00:00 +0000, :status=>"Fri, March 11th at 9:00 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"uva", :home_score=>0, :away_team=>"mia", :away_score=>0, :game_date=>Sat, 12 Mar 2016 02:00:00 +0000, :status=>"Fri, March 11th at 9:00 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"xav", :home_score=>0, :away_team=>"hall", :away_score=>0, :game_date=>Sat, 12 Mar 2016 02:00:00 +0000, :status=>"Fri, March 11th at 9:00 PM EST", :league=>"mens-college-basketball"},
#     {:home_team=>"utah", :home_score=>0, :away_team=>"cal", :away_score=>0, :game_date=>Sat, 12 Mar 2016 04:30:00 +0000, :status=>"Fri, March 11th at 11:30 PM EST", :league=>"mens-college-basketball"}
# ]
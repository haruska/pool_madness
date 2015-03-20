class SportsScores
  class ScoreTeam
    include ActiveAttr::Model

    attribute :name
    attribute :seed
    attribute :score_id
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
end
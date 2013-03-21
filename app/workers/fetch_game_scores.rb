class FetchGameScores
  include Sidekiq::Worker

  def perform
    res = HTTParty.get('http://scores.pool-madness.com:8888/index.json')

    res.select {|g| g['time'] == 'Final' }.each do |r|
      ids = [r['home_team']['team_id'], r['away_team']['team_id']]

      game = Game.all.select {|g| ids.include?(g.first_team.try(:score_team_id))  && ids.include?(g.second_team.try(:score_team_id))}.first
      if game.present? && game.score_one.blank? && game.score_two.blank?
        if r['home_team']['team_id'] == game.first_team.score_team_id
          game.score_one = r['home_team']['total']
          game.score_two = r['away_team']['total']
        else
          game.score_one = r['away_team']['total']
          game.score_two = r['home_team']['total']
        end
        game.save!
      end
    end
  end
end
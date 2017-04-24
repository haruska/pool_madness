namespace :seed_data do
  desc "Generate scores for every game"
  task random_scores: :environment do
    Game.all.each { |game| random_score(game) }
  end

  desc "Clear all scores"
  task clear_scores: :environment do
    Game.all.each do |game|
      game.score_one = nil
      game.score_two = nil
      game.save!
    end
  end

  desc "Fill in first two rounds of games with scores"
  task random_scores_partial: :environment do
    [1, 2].each { |round| Game.round_for(round).each { |game| random_score(game) } }
  end

  def random_score(game)
    game.score_one = rand(50) + 50
    game.score_two = rand(50) + 50 until game.score_two.present? && game.score_one != game.score_two
    game.save!
  end
end

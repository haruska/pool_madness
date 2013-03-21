class BracketScores
  include Sidekiq::Worker

  def perform
    Bracket.select(:id).all.each do |b|
      UpdateBracketPoints.perform_async(b.id)
    end
  end
end
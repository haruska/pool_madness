# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bracket do
    user
    pool

    trait :completed do
      tie_breaker { Faker::Number.between(100, 200) }

      after(:create) do |bracket|
        (1..4).each do |round|
          Team::REGIONS.each do |region|
            bracket.tournament.round_for(round, region).each do |game|
              pick = bracket.picks.find_by(game_id: game.id)
              pick.team = [pick.first_team, pick.second_team].sample
              pick.save!
            end
          end
        end

        (5..6).each do |round|
          bracket.tournament.round_for(round).each do |game|
            pick = bracket.picks.find_by(game_id: game.id)
            pick.team = [pick.first_team, pick.second_team].sample
            pick.save!
          end
        end
      end
    end
  end
end

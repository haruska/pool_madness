# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bracket do
    user
    pool

    trait :completed do
      tie_breaker { Faker::Number.between(100, 200) }

      before(:create) do |bracket|
        bracket.tournament.num_games.times do |i|
          bracket.update_choice(i+1, [0,1].sample)
        end
      end
    end

    before(:create) do |bracket|
      PoolUser.find_or_create_by(user_id: bracket.user_id, pool_id: bracket.pool_id)
    end
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bracket do
    user
    pool
    tie_breaker { Faker::Number.between(100, 200) }
    tree_decisions 0
    tree_mask 0b1111111111111111111111111111111111111111111111111111111111111110

    trait :completed do
      after(:build) do |bracket|
        bracket.tournament.num_games.times do |i|
          bracket.update_choice(i + 1, [0, 1].sample)
        end
      end
    end

    trait :winning do
      tree_decisions { pool.tournament.game_decisions }
      payment_state { Bracket.payment_states[:paid] }

      after(:create) do |bracket|
        bracket.calculate_points
        bracket.calculate_possible_points
        bracket.bracket_point.update(best_possible: 0)
      end
    end

    trait :paid do
      payment_state { Bracket.payment_states[:paid] }
    end

    before(:create) do |bracket|
      PoolUser.find_or_create_by(user_id: bracket.user_id, pool_id: bracket.pool_id)
    end
  end
end

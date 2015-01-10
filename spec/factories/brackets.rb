# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bracket do
    user

    trait :completed do
      tie_breaker { Faker::Number.between(100, 200) }

      after(:create) do |bracket|
        bracket.picks.each do |pick|
          pick.team = [pick.first_team, pick.second_team].sample
          pick.save!
        end
      end
    end
  end
end

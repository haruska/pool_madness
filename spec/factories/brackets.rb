# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bracket do
    user
    pool

    trait :completed do
      tie_breaker { Faker::Number.between(100, 200) }

      after(:create) do |bracket|
        bracket.picks.each do |pick|
          pick.update(choice: [0,1].sample)
        end
      end
    end
  end
end

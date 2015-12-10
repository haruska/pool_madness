FactoryGirl.define do
  factory :round do
    tournament
    name { Faker::Lorem.words(2).join(" ") }
    sequence(:number) { |n| n }
    start_date { Faker::Date.forward }
    end_date { Faker::Date.forward }
  end
end

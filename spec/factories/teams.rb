# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team do
    tournament
    region { Team::REGIONS.sample }
    sequence(:seed)
    name { Faker::Name }
  end
end

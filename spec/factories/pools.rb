FactoryGirl.define do
  factory :pool do
    tournament
    name { Faker::Company.name }
  end
end

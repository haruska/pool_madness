# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :possible_outcome do
    skip_create
    possible_outcome_set
  end
end

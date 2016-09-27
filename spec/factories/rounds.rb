FactoryGirl.define do
  factory :round do
    tournament
    number { (1..tournament.num_rounds).to_a.sample }
  end
end

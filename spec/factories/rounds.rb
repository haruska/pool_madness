FactoryGirl.define do
  factory :round do
    tournament
    name { Faker::Lorem.words(2).join(" ") }
    number { tournament.rounds.map(&:number).max + 1  }
    start_date { Faker::Date.forward }
    end_date { Faker::Date.forward }
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tournament do
    tip_off { 1.week.ago }

    after(:build) do |tournament|
      tournament.name ||= "#{tournament.tip_off.strftime('%Y')} #{Faker::Company.name} Tournament"
    end

    after(:create) do |tournament|
      {
        Team::MIDWEST => [
          "Wichita St",
          "Michigan",
          "Duke",
          "Louisville",
          "St Louis",
          "UMass",
          "Texas",
          "Kentucky",
          "Kansas St",
          "Arizona St",
          "Play-In MW11",
          "Play-In MW12",
          "Manhattan",
          "Mercer",
          "Wofford",
          "Play-In MW16"
        ],
        Team::WEST => [
          "Arizona",
          "Wisconsin",
          "Creighton",
          "San Diego St",
          "Oklahoma",
          "Baylor",
          "Oregon",
          "Gonzaga",
          "Oklahoma St",
          "BYU",
          "Nebraska",
          "N Dakota St",
          "New Mex St",
          "UL-Lafayette",
          "American",
          "Weber St"
        ],
        Team::SOUTH => [
          "Florida",
          "Kansas",
          "Syracuse",
          "UCLA",
          "VCU",
          "Ohio St",
          "New Mexico",
          "Colorado",
          "Pittsburgh",
          "Stanford",
          "Dayton",
          "SF Austin",
          "Tulsa",
          "W Michigan",
          "E Kentucky",
          "Play-In S16"
        ],
        Team::EAST => [
          "Virginia",
          "Villanova",
          "Iowa St",
          "Michigan St",
          "Cincinnati",
          "N Carolina",
          "Connecticut",
          "Memphis",
          "George Wash",
          "St Joes",
          "Providence",
          "Harvard",
          "Delaware",
          "NC Central",
          "UW Milwauk",
          "Coast Car"
        ]
      }.each do |region, team_names|
        team_names.each_with_index do |name, i|
          tournament.teams.create region: region, seed: i + 1, name: name
        end
      end

      tournament.rounds.create(
          name: "1st ROUND",
          start_date: DateTime.parse("2015-03-19"),
          end_date: DateTime.parse("2015-03-20"),
          number: 1
      )

      tournament.rounds.create(
          name: "2nd ROUND",
          start_date: DateTime.parse("2015-03-21"),
          end_date: DateTime.parse("2015-03-22"),
          number: 2
      )

      tournament.rounds.create(
          name: "SWEET 16",
          start_date: DateTime.parse("2015-03-26"),
          end_date: DateTime.parse("2015-03-27"),
          number: 3
      )

      tournament.rounds.create(
          name: "ELITE EIGHT",
          start_date: DateTime.parse("2015-03-28"),
          end_date: DateTime.parse("2015-03-29"),
          number: 4
      )

      tournament.rounds.create(
          name: "FINAL FOUR",
          start_date: DateTime.parse("2015-04-04"),
          end_date: DateTime.parse("2015-04-04"),
          number: 5
      )

      tournament.rounds.create(
          name: "CHAMPION",
          start_date: DateTime.parse("2015-04-06"),
          end_date: DateTime.parse("2015-04-06"),
          number: 6
      )

      team_slot = tournament.teams.count

      sort_order = [1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15]
      ["South", "East", "West", "Midwest"].each do |region|
        sort_order.each_slice(2) do |i, j|
          team_one = tournament.teams.find_by(region: region, seed: i)
          team_two = tournament.teams.find_by(region: region, seed: j)

          team_one.update(starting_slot: team_slot)
          team_two.update(starting_slot: team_slot + 1)

          team_slot += 2
        end
      end
    end

    trait :with_first_two_rounds_completed do
      tip_off { 1.week.ago }

      after(:create) do |tournament|
        (1..2).each do |round|
          tournament.round_for(round).each do |game|
            tournament.update_game(game.slot, [0, 1].sample)
          end
        end
        tournament.save
      end
    end

    trait :completed do
      tip_off { 4.weeks.ago }

      after(:create) do |tournament|
        tournament.num_games.times do |i|
          tournament.update_game(i+1, [0, 1].sample)
        end
        tournament.save
      end
    end

    trait :started do
      tip_off { 1.week.ago }
    end

    trait :not_started do
      tip_off { 4.days.from_now }
    end
  end
end

FactoryGirl.define do
  factory :tournament do
    tip_off { 1.week.ago }

    after(:build) do |tournament|
      tournament.name ||= "#{tournament.tip_off.strftime('%Y')} #{Faker::Company.name} Tournament"
    end

    after(:create) do |tournament|
      {
        Team::EAST => [
          "Villanova",
          "Duke",
          "Baylor",
          "Florida",
          "Virginia",
          "SMU",
          "S Carolina",
          "Wisconsin",
          "Va Tech",
          "Marquette",
          "PlayIn E11",
          "UNC-Wilm",
          "ETSU",
          "New Mex St",
          "Troy",
          "PlayIn E16"
        ],
        Team::WEST => [
          "Gonzaga",
          "Arizona",
          "Florida St",
          "W Virginia",
          "Notre Dame",
          "Maryland",
          "St Mary's",
          "NWestern",
          "Vanderbilt",
          "VCU",
          "Xavier",
          "Princeton",
          "Bucknell",
          "FGCU",
          "N Dakota",
          "S Dak St"
        ],
        Team::MIDWEST => [
          "Kansas",
          "Louisville",
          "Oregon",
          "Purdue",
          "Iowa St",
          "Creighton",
          "Michigan",
          "Miami",
          "Michigan St",
          "Oklahoma St",
          "Rhode Island",
          "Nevada",
          "Vermont",
          "Iona",
          "Jax St",
          "PlayIn MW16"
        ],
        Team::SOUTH => [
          "N Carolina",
          "Kentucky",
          "UCLA",
          "Butler",
          "Minnesota",
          "Cincinnati",
          "Dayton",
          "Arkansas",
          "Seton Hall",
          "Wichita St",
          "PlayIn S11",
          "Middle Tenn",
          "Winthrop",
          "Kent St",
          "N Kentucky",
          "Texas So"
        ]
      }.each do |region, team_names|
        team_names.each_with_index do |name, i|
          tournament.teams.create region: region, seed: i + 1, name: name
        end
      end

      team_slot = tournament.teams.count

      sort_order = [1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15]
      Team::REGIONS.each do |region|
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

    trait :in_final_four do
      tip_off { 2.weeks.ago }

      after(:create) do |tournament|
        (1..4).each do |round|
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
          tournament.update_game(i + 1, [0, 1].sample)
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

    trait :archived do
      tip_off { 7.months.ago }
    end

    trait :sweet_16 do
      num_rounds 4
    end
  end
end

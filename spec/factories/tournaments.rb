# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tournament do
    tip_off { 1.week.ago }
    
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
            "UW Milwaukee",
            "Coast Car"
          ]
        }.each do |region, team_names|
          team_names.each_with_index do |name, i|
            tournament.teams.create region: region, seed: i + 1, name: name
          end
        end

        Team::REGIONS.each do |region|
          # 64 teams
          i, j = 1, 16
          while i < j
            team_one = tournament.teams.find_by(region: region, seed: i)
            team_two = tournament.teams.find_by(region: region, seed: j)
            tournament.games.create team_one: team_one, team_two: team_two
            i += 1
            j -= 1
          end

          # 32 teams
          [[1, 8], [5, 4], [6, 3], [7, 2]].each do |one, two|
            game_one = tournament.games.find_by(team_one_id: tournament.teams.find_by(region: region, seed: one))
            game_two = tournament.games.find_by(team_one_id: tournament.teams.find_by(region: region, seed: two))
            tournament.games.create game_one: game_one, game_two: game_two
          end

          # Sweet 16
          [[1, 5], [6, 7]].each do |one, two|
            game_one = tournament.games.find_by(team_one_id: tournament.teams.find_by(region: region, seed: one)).next_game
            game_two = tournament.games.find_by(team_one_id: tournament.teams.find_by(region: region, seed: two)).next_game
            tournament.games.create game_one: game_one, game_two: game_two
          end

          # Great 8
          game_one = tournament.games.find_by(team_one_id: tournament.teams.find_by(region: region, seed: 1)).next_game.next_game
          game_two = tournament.games.find_by(team_one_id: tournament.teams.find_by(region: region, seed: 6)).next_game.next_game
          tournament.games.create game_one: game_one, game_two: game_two
        end

        # Final 4
        game_one = tournament.games.find_by(team_one_id: tournament.teams.find_by(region: Team::MIDWEST, seed: 1)).next_game.next_game.next_game
        game_two = tournament.games.find_by(team_one_id: tournament.teams.find_by(region: Team::WEST, seed: 1)).next_game.next_game.next_game
        champ_one = tournament.games.create game_one: game_one, game_two: game_two

        game_one = tournament.games.find_by(team_one_id: tournament.teams.find_by(region: Team::SOUTH, seed: 1)).next_game.next_game.next_game
        game_two = tournament.games.find_by(team_one_id: tournament.teams.find_by(region: Team::EAST, seed: 1)).next_game.next_game.next_game
        champ_two = tournament.games.create game_one: game_one, game_two: game_two

        # Championship
        tournament.games.create game_one: champ_one, game_two: champ_two
    end

    trait :with_first_two_rounds_completed do
      tip_off { 1.week.ago }

      after(:create) do |tournament|
        (1..2).each do |round|
          Team::REGIONS.each do |region|
            tournament.round_for(round, region).each do |game|
              while game.score_one.nil? || game.score_one == game.score_two
                game.update_attributes!(score_one: Faker::Number.between(60, 90), score_two: Faker::Number.between(60, 90))
              end
            end
          end
        end
      end
    end

    trait :completed do
      tip_off { 4.weeks.ago }

      after(:create) do |tournament|
        tournament.games.all.each do |game|
          while game.score_one.nil? || game.score_one == game.score_two
            game.update_attributes(score_one: Faker::Number.between(60, 90), score_two: Faker::Number.between(60, 90))
          end
        end
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

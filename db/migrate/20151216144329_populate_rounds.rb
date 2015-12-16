class PopulateRounds < ActiveRecord::Migration
  def change
    Tournament.all.each do |tournament|
      if tournament.num_rounds == 6
        tournament.rounds.create_with(
            name: "1st ROUND",
            start_date: DateTime.parse("2015-03-19"),
            end_date: DateTime.parse("2015-03-20")
        ).find_or_create_by(number: 1)

        tournament.rounds.create_with(
            name: "2nd ROUND",
            start_date: DateTime.parse("2015-03-21"),
            end_date: DateTime.parse("2015-03-22")
        ).find_or_create_by(number: 2)

        tournament.rounds.create_with(
            name: "SWEET 16",
            start_date: DateTime.parse("2015-03-26"),
            end_date: DateTime.parse("2015-03-27")
        ).find_or_create_by(number: 3)

        tournament.rounds.create_with(
            name: "ELITE EIGHT",
            start_date: DateTime.parse("2015-03-28"),
            end_date: DateTime.parse("2015-03-29")
        ).find_or_create_by(number: 4)

        tournament.rounds.create_with(
            name: "FINAL FOUR",
            start_date: DateTime.parse("2015-04-04"),
            end_date: DateTime.parse("2015-04-04")
        ).find_or_create_by(number: 5)

        tournament.rounds.create_with(
            name: "CHAMPION",
            start_date: DateTime.parse("2015-04-06"),
            end_date: DateTime.parse("2015-04-06")
        ).find_or_create_by(number: 6)

      else
        tournament.rounds.create_with(
            name: "SWEET 16",
            start_date: DateTime.parse("2015-03-26"),
            end_date: DateTime.parse("2015-03-27")
        ).find_or_create_by(number: 1)

        tournament.rounds.create_with(
            name: "ELITE EIGHT",
            start_date: DateTime.parse("2015-03-28"),
            end_date: DateTime.parse("2015-03-29")
        ).find_or_create_by(number: 2)

        tournament.rounds.create_with(
            name: "FINAL FOUR",
            start_date: DateTime.parse("2015-04-04"),
            end_date: DateTime.parse("2015-04-04")
        ).find_or_create_by(number: 3)

        tournament.rounds.create_with(
            name: "CHAMPION",
            start_date: DateTime.parse("2015-04-06"),
            end_date: DateTime.parse("2015-04-06")
        ).find_or_create_by(number: 4)
      end
    end
  end
end

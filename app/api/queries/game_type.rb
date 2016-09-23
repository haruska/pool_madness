module Queries
  GameType = GraphQL::ObjectType.define do
    name "Game"
    description "A game in a tournament"

    interfaces [NodeInterface.interface]
    global_id_field :id

    field :slot, !types.Int

    field :previous_slot_one, types.Int, property: :left_position
    field :previous_slot_two, types.Int, property: :right_position

    field :next_game_slot, types.Int
    field :next_game_position, types.Int, property: :next_slot # 1 or 2

    field :team_one, TeamType
    field :team_two, TeamType
    field :winning_team, TeamType, property: :team

    field :choice, types.Int, property: :decision # 0 or 1
  end
end

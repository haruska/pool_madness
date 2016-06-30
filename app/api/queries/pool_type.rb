module Queries
  PoolType = GraphQL::ObjectType.define do
    name "Pool"
    description "A bracket pool for a tournament"

    interfaces [NodeInterface.interface]
    global_id_field :id

    field :model_id, !types.Int, property: :id
    field :tournament, !TournamentType
    field :name, !types.String
    field :invite_code, !types.String
    field :entry_fee, !types.Int
    field :total_collected, !types.Int
    field :started, !types.Boolean, property: :started?
    field :display_best, !types.Boolean, property: :display_best?
    field :admins, types[!UserType]

    connection :brackets, BracketType.connection_type do
      resolve lambda { |pool, _args, context|
        if pool.started?
          pool.brackets.includes(:bracket_point).joins(:bracket_point).order("best_possible asc", "points desc", "possible_points desc")
        else
          brackets = pool.brackets.where(user_id: context[:current_user])
          brackets.to_a.sort_by { |x| [[:ok, :unpaid, :incomplete].index(x.status), x.name] }
        end
      }
    end
  end
end

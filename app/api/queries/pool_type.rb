module Queries
  POOL_BRACKETS_LAMBDA = lambda { |pool, _args, context|
    if pool.started?
      pool.brackets.includes(:bracket_point, :user).joins(:bracket_point).order("points desc", "possible_points desc")
    else
      pool.brackets.where(user_id: context[:current_user]).order(:payment_state)
    end
  }

  POOL_POSSIBILITIES_LAMBDA = lambda { |pool, _args, _context|
    if (1..3).cover?(pool.tournament.num_games_remaining)
      outcome_set = PossibleOutcomeSet.new(tournament: pool.tournament, exclude_eliminated: true)
      outcome_set.all_outcomes_by_winners(pool)
    end
  }

  PoolType = GraphQL::ObjectType.define do
    name "Pool"
    description "A bracket pool for a tournament"

    interfaces [GraphQL::Relay::Node.interface]
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

    field :possibilities do
      type types[PossibilityType]
      resolve POOL_POSSIBILITIES_LAMBDA
    end

    field :bracket_count do
      type !types.Int
      resolve ->(pool, _args, _context) { pool.brackets.count }
    end

    connection :brackets, -> { BracketType.connection_type } do
      resolve POOL_BRACKETS_LAMBDA
    end
  end
end

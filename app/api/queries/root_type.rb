module Queries
  RootType = GraphQL::ObjectType.define do
    name "RootType"
    description "The query root of this schema"

    field :node, field: NodeInterface.field

    field :lists do
      type !ListsType
      resolve -> (_object, _args, _context) { {} }
    end

    field :pool do
      type !PoolType
      argument :model_id, !types.ID, "The ID of the Pool"
      resolve lambda { |_object, args, context|
        if context[:current_ability]
          Pool.accessible_by(context[:current_ability]).find_by!(id: args["model_id"])
        else
          GraphQL::ExecutionError.new("You must be signed in to view this information")
        end
      }
    end

    field :bracket do
      type !BracketType
      argument :model_id, !types.ID, "The ID of the Bracket"
      resolve lambda { |_object, args, context|
        if context[:current_ability]
          Bracket.accessible_by(context[:current_ability]).find_by!(id: args["model_id"])
        else
          GraphQL::ExecutionError.new("You must be signed in to view this information")
        end
      }
    end

    field :current_user do
      type !CurrentUserType
      resolve lambda { |_object, _args, context|
        context[:current_user] || GraphQL::ExecutionError.new("You must be signed in to view this information")
      }
    end
  end
end

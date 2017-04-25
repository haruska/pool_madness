module Queries
  PoolsType = GraphQL::ListType.new(of_type: PoolType)
end

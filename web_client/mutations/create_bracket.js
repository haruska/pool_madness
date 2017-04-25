import Relay, { Mutation } from 'react-relay'

export default class CreateBracketMutation extends Mutation {
  getMutation () {
    return Relay.QL`mutation {create_bracket}`
  }

  getVariables () {
    const { name, tie_breaker, game_decisions, game_mask } = this.props
    return {pool_id: this.props.pool.id, name, tie_breaker, game_decisions, game_mask}
  }

  getFatQuery () {
    return Relay.QL`
      fragment on CreateBracketPayload {
        bracket_edge
        pool
      }
    `
  }

  getConfigs () {
    return [
      {
        type: 'RANGE_ADD',
        parentName: 'pool',
        parentID: this.props.pool.id,
        connectionName: 'brackets',
        edgeName: 'bracket_edge',
        rangeBehaviors: {
          '': 'append'
        }
      },
      {
        type: 'REQUIRED_CHILDREN',
        children: [
          Relay.QL`
            fragment on CreateBracketPayload {
              errors {
                key
                messages
              }
            }
          `
        ]
      }
    ]
  }

  static fragments = {
    pool: () => Relay.QL`
      fragment on Pool {
        id
      }
    `
  }
}

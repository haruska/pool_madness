import Relay, { Mutation } from 'react-relay'

export default class UpdateBracketMutation extends Mutation {
  getMutation() {
    return Relay.QL`mutation {update_bracket}`
  }

  getVariables() {
    const { name, tie_breaker, game_decisions, game_mask } = this.props
    return { bracket_id: this.props.bracket.id, name, tie_breaker, game_decisions, game_mask }
  }

  getFatQuery() {
    return Relay.QL`
      fragment on UpdateBracketPayload {
        bracket {
          name
          tie_breaker
          game_decisions
          game_mask
          status
        }
      }
    `
  }

  getConfigs() {
    return [
      {
        type: 'FIELDS_CHANGE',
        fieldIDs: {
          bracket: this.props.bracket.id
        }
      },
      {
        type: 'REQUIRED_CHILDREN',
        children: [
          Relay.QL`
            fragment on UpdateBracketPayload {
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

  getOptimisticResponse() {
    const { bracket, name, tie_breaker, game_decisions, game_mask } = this.props
    return {
      bracket: {
        id: bracket.id,
        name,
        tie_breaker,
        game_decisions,
        game_mask
      }
    }
  }

  static fragments = {
    bracket: () => Relay.QL`
      fragment on Bracket {
        id
      }
    `
  }
}
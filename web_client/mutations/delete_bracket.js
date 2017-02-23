import Relay, { Mutation } from 'react-relay'

export default class DeleteBracketMutation extends Mutation {
  getMutation() {
    return Relay.QL`mutation {delete_bracket}`
  }

  getVariables() {
    return {bracket_id: this.props.bracket.id}
  }

  getFatQuery() {
    return Relay.QL`
      fragment on DeleteBracketPayload {
        deleted_bracket_id
        pool
      }
    `
  }

  getConfigs() {
    return [{
      type: 'NODE_DELETE',
      parentName: 'pool',
      parentID: this.props.bracket.pool.id,
      connectionName: 'brackets',
      deletedIDFieldName: 'deleted_bracket_id'
    }]
  }

  static fragments = {
    bracket: () => Relay.QL`
      fragment on Bracket {
        id
        pool {
          id
        }
      }
    `
  }
}
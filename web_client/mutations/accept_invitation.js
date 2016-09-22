import Relay, { Mutation } from 'react-relay'

export default class AcceptInvitationMutation extends Mutation {
  getMutation() {
    return Relay.QL`mutation {accept_invitation}`
  }

  getVariables() {
    return this.props
  }

  getFatQuery() {
    return Relay.QL`
      fragment on AcceptInvitationPayload {
        clientMutationId
      }
    `
  }

  getConfigs() {
    return []
  }
}
import Relay, { Mutation } from 'react-relay'

export default class UpdateProfileMutation extends Mutation {
  getMutation() {
    return Relay.QL`mutation {update_profile}`
  }

  getVariables() {
    return {name: this.props.name, email: this.props.email}
  }

  getFatQuery() {
    return Relay.QL`
      fragment on UpdateProfilePayload {
        current_user {
          name
          email
        }
      }
    `
  }

  getConfigs() {
    return [{
      type: 'FIELDS_CHANGE',
      fieldIDs: {
        current_user: this.props.current_user.id
      }
    }]
  }

  getOptimisticResponse() {
    const { current_user, name, email } = this.props

    return {
      current_user: {
        id: current_user.id,
        name: name,
        email: email
      }
    }
  }

  static fragments = {
    current_user: () => Relay.QL`
      fragment on CurrentUser {
        id
      }
    `
  }
}
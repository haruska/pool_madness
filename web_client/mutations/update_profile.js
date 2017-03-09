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
      fragment on UpdateProfilePayload { viewer }
    `
  }

  getConfigs() {
    return [
      {
        type: 'FIELDS_CHANGE',
        fieldIDs: {
          viewer: this.props.viewer.id
        }
      },
      {
        type: 'REQUIRED_CHILDREN',
        children: [
          Relay.QL`
            fragment on UpdateProfilePayload {
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
    const { viewer, name, email } = this.props

    return {
      viewer: {
        id: viewer.id,
        current_user: {
          name: name,
          email: email
        }
      }
    }
  }

  static fragments = {
    viewer: () => Relay.QL`
      fragment on Viewer {
        id
      }
    `
  }
}
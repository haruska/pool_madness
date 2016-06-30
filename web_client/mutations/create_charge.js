import { Mutation } from 'react-relay'
import Relay from 'react-relay'

export default class CreateChargeMutation extends Mutation {
  getMutation() {
    return Relay.QL`mutation {create_charge}`
  }

  getVariables() {
    return {
      pool_id: this.props.pool.id,
      token: this.props.token
    }
  }

  getFatQuery() {
    return Relay.QL`
      fragment on CreateChargePayload {
        pool {
          brackets(first: 1000) {
            edges {
              node {
                status
              }
            }
          }
        }
      }
    `
  }

  getConfigs() {
    return [
      {
        type: 'FIELDS_CHANGE',
        fieldIDs: {
          pool: this.props.pool.id
        }
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
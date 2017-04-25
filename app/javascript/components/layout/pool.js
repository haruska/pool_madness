import React, { Component } from 'react'
import Relay from 'react-relay'
import Layout from './layout'

class PoolLayout extends Component {
  render () {
    return (
      <Layout {...this.props}>
        {this.props.children}
      </Layout>
    )
  }
}

export default Relay.createContainer(PoolLayout, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        model_id
        started
        tournament {
          games_remaining
        }
        admins {
          model_id
        }
      }
    `,
    viewer: () => Relay.QL`
      fragment on Viewer {
        current_user {
          model_id
          admin
        }
      }
    `
  }
})

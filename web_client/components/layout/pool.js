import React from 'react'
import Relay from 'react-relay'
import Layout from './layout'

let Component = React.createClass({
  render() {
    return (
      <Layout {...this.props}>
        {this.props.children}
      </Layout>
    )
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        model_id
        started
        tournament {
          games_remaining
        }
        admins(first: 1000) {
          edges {
            node {
              model_id
            }
          }  
        }
      }
    `,
    current_user: () => Relay.QL`
      fragment on CurrentUser {
        model_id
        admin 
      }
    `
  }
})

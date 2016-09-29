import React, { Component } from 'react'
import Relay from 'react-relay'
import PoolLayout from './pool'

class BracketLayout extends Component {
  render() {
    const { bracket, current_user } = this.props
    return (
      <PoolLayout pool={bracket.pool} current_user={current_user}>
        {this.props.children}
      </PoolLayout>
    )
  }
}

export default Relay.createContainer(BracketLayout, {
  fragments: {
    bracket: () => Relay.QL`
      fragment on Bracket {
        pool {
          ${PoolLayout.getFragment('pool')}
        }
      }
    `,
    current_user: () => Relay.QL`
      fragment on CurrentUser {
        ${PoolLayout.getFragment('current_user')}
      }
    `
  }
})

import React, { Component } from 'react'
import Relay from 'react-relay'
import PoolLayout from './pool'

class BracketLayout extends Component {
  shouldComponentUpdate (nextProps) {
    if (nextProps.bracket) {
      return true
    }
    return false
  }

  render () {
    const { bracket, viewer } = this.props
    return (
      <PoolLayout pool={bracket.pool} viewer={viewer}>
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
    viewer: () => Relay.QL`
      fragment on Viewer {
        ${PoolLayout.getFragment('viewer')}
      }
    `
  }
})

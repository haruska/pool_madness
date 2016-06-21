import React from 'react'
import Relay from 'react-relay'

let Component = React.createClass({
  contextTypes: {
    router: React.PropTypes.object.isRequired
  },

  componentWillMount() {
    this.redirectToBracketList()
  },

  redirectToBracketList() {
    let pool = this.props.pool

    if(pool.started) {
      this.context.router.push(`/pools/${pool.model_id}/brackets`)
    }
    else {
      this.context.router.push(`/pools/${pool.model_id}/my_brackets`)
    }
  },

  render() {
    return this.props.children
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        model_id
        started
      }
    `
  }
})

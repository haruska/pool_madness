import React, { Component } from 'react'
import Relay from 'react-relay'

class Pool extends Component {
  static contextTypes = {
    router: React.PropTypes.object.isRequired
  }

  componentWillMount() {
    this.redirectToBracketList()
  }

  redirectToBracketList = () => {
    const { pool } = this.props

    if(pool.started) {
      this.context.router.push(`/pools/${pool.model_id}/brackets`)
    }
    else {
      this.context.router.push(`/pools/${pool.model_id}/my_brackets`)
    }
  }

  render() {
    return this.props.children
  }
}

export default Relay.createContainer(Pool, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        model_id
        started
      }
    `
  }
})

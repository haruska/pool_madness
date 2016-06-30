import React from 'react'
import Relay from 'react-relay'

import PoolSettings from '../pools/settings'
import PoolPrizes from '../pools/prizes'
import PoolScoring from '../pools/scoring'
import PoolAdminList from '../pools/admin_list'

let Component = React.createClass({
  contextTypes: {
    setPageTitle: React.PropTypes.func.isRequired
  },

  componentWillMount() {
    this.context.setPageTitle("Rules and Scoring")
  },

  componentWillUnmount() {
    this.context.setPageTitle()
  },

  render() {
    let { pool } = this.props

    return <div className="pool-rules-scoring">
      <PoolSettings pool={pool}/>
      <PoolPrizes pool={pool}/>
      <PoolScoring pool={pool}/>
      <PoolAdminList pool={pool}/>
    </div>
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        ${PoolSettings.getFragment('pool')}
        ${PoolPrizes.getFragment('pool')}
        ${PoolScoring.getFragment('pool')}
        ${PoolAdminList.getFragment('pool')}
      }
    `
  }
})

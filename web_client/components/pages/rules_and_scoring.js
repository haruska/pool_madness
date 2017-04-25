import React, { Component } from 'react'
import Relay from 'react-relay'

import PoolSettings from 'components/pools/settings'
import PoolPrizes from 'components/pools/prizes'
import PoolScoring from 'components/pools/scoring'
import PoolAdminList from 'components/pools/admin_list'

class RulesAndScoring extends Component {
  static contextTypes = {
    setPageTitle: React.PropTypes.func.isRequired
  }

  componentWillMount () {
    this.context.setPageTitle('Rules and Scoring')
  }

  componentWillUnmount () {
    this.context.setPageTitle()
  }

  render () {
    let { pool } = this.props

    return <div className='pool-rules-scoring'>
      <PoolSettings pool={pool} />
      <PoolPrizes pool={pool} />
      <PoolScoring pool={pool} />
      <PoolAdminList pool={pool} />
    </div>
  }
}

export default Relay.createContainer(RulesAndScoring, {
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

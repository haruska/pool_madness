import React from 'react'
import Relay from 'react-relay'
import BracketList from '../brackets/bracket_list'
import EliminationBracketList from '../brackets/elimination_bracket_list'

var Component = React.createClass({
  render() {
    let pool = this.props.pool

    return <div className='pool-details'>
      { pool.display_best ? <EliminationBracketList pool={pool}/> : <BracketList pool={pool}/> }
    </div>
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        display_best
        ${BracketList.getFragment('pool')}
        ${EliminationBracketList.getFragment('pool')}
      }
    `
  }
})
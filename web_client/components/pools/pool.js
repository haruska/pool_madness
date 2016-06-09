import React from 'react'
import Relay from 'react-relay'
import BracketList from '../brackets/bracket_list'
import UserBracketList from '../brackets/user_bracket_list'

var Component = React.createClass({
  render() {
    let pool = this.props.pool

    var bracketList
    if(pool.started) {
      bracketList = <BracketList pool={pool} showEliminated={pool.display_best}/>
    } else {
      bracketList = <UserBracketList pool={pool} />
    }

    return <div className='pool-details'>
      {bracketList}
    </div>
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        started
        display_best
        ${UserBracketList.getFragment('pool')}
        ${BracketList.getFragment('pool')}
      }
    `
  }
})
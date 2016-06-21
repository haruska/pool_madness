import React from 'react'
import Relay from 'react-relay'
import BracketList from '../brackets/bracket_list'
import UserBracketList from '../brackets/user_bracket_list'

var Component = React.createClass({
  contextTypes: {
    setCurrentPool: React.PropTypes.func.isRequired
  },

  componentWillMount() {
    this.context.setCurrentPool(this.props.pool)
  },

  componentWillUnmount() {
    this.context.setCurrentPool()
  },

  bracketList() {
    let pool = this.props.pool

    if(pool.started) {
      return <BracketList pool={pool} />
    } else {
      return <UserBracketList pool={pool} />
    }  
  },
  
  render() {
    return <div className='pool-details'>
      {this.bracketList()}
    </div>
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        model_id
        started
        ${BracketList.getFragment('pool')}
        ${UserBracketList.getFragment('pool')}
      }
    `
  }
})
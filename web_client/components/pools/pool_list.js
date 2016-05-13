import React from 'react'
import Relay from 'react-relay'

function InviteCode(props) {
  let pool = props.pool
  let now = new Date()
  let tip_off = new Date(pool.tournament.tip_off)


  if (tip_off > now) {
    return <li className='invite-code'>Invite Code: {pool.invite_code}</li>
  } else {
    return <li className='invite-code'/>
  }
}


function Pool(props) {
  let pool = props.pool
  let poolPath = `/pools/${pool.model_id}`



  return (
    <div className='pool'>
      <a href={poolPath}>
        <ul>
          <li className='name'>{pool.name} Pool</li>
          <li className='tournament-name'>{pool.tournament.name}</li>
          <InviteCode pool={pool} />
        </ul>
      </a>
    </div>
  )
}

var Component = React.createClass({
  contextTypes: {
    setPageTitle: React.PropTypes.func.isRequired
  },

  componentWillMount() {
    this.context.setPageTitle("Pools")
  },

  componentWillUnmount() {
    this.context.setPageTitle()
  },

  render() {
    let pools = this.props.lists.pools
    return <div className='pool-list'>
      <div className='pools'>
        {pools.map(pool => <Pool key={pool.id} pool={pool} />)}
      </div>
      <div className='actions'>
        <a className='button minor' href='/archived_pools'>Previous Years</a>
      </div>
    </div>
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    lists: () => Relay.QL`
      fragment on Lists {
        pools {
          id
          model_id
          name
          invite_code
          tournament {
            id
            name
            tip_off
          }
        }
      }
    `
  }
})
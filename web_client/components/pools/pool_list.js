import React, { Component } from 'react'
import Relay from 'react-relay'
import { Link } from 'react-router'
import { size, filter } from 'lodash'

class InviteCode extends Component {
  render() {
    const { pool } = this.props
    const now = new Date()
    const tip_off = new Date(pool.tournament.tip_off)

    if (tip_off > now) {
      return <li className='invite-code'>Invite Code: {pool.invite_code}</li>
    } else {
      return <li className='invite-code'/>
    }
  }
}

class Pool extends Component {
  render() {
    const { pool } = this.props
    const poolPath = `/pools/${pool.model_id}`

    return (
      <div className='pool'>
        <Link to={poolPath}>
          <ul>
            <li className='name'>{pool.name} Pool</li>
            <li className='tournament-name'>{pool.tournament.name}</li>
            <InviteCode pool={pool}/>
          </ul>
        </Link>
      </div>
    )
  }
}

class PoolList extends Component {
  static contextTypes = {
    setPageTitle: React.PropTypes.func.isRequired
  }

  state = { archived: false }

  componentWillMount() {
    this.context.setPageTitle("Pools")
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  componentDidMount() {
    this.props.relay.forceFetch()
  }

  currentPools = () => {
    return filter(this.props.lists.pools, pool => { return !pool.tournament.archived })
  }

  archivedPools = () => {
    return filter(this.props.lists.pools, pool => { return pool.tournament.archived })
  }

  hasArchivedPools = () => {
    return size(this.archivedPools()) > 0
  }

  handlePreviousYearsClick = () => {
    this.setState({archived: true})
    this.context.setPageTitle("Archived Pools")
  }

  handleCurrentPoolsClick = () => {
    this.setState({archived: false})
    this.context.setPageTitle("Pools")
  }

  poolListButton = () => {
    if(this.state.archived) {
      return (
        <div className='button' onClick={this.handleCurrentPoolsClick}>
          <i className='fa fa-arrow-left' />
          &nbsp;
          Current Pools
        </div>
      )
    } else if(this.hasArchivedPools()) {
      return <div className='button minor' onClick={this.handlePreviousYearsClick}>Previous Years</div>
    }
  }

  render() {
    let pools = this.state.archived ? this.archivedPools() : this.currentPools()

    if(size(pools) < 1) {
      return <div className='pool-list'>
        <p className='no-pools'>You are not a member of any tournament pools.</p>
        <div className='actions'>
          <Link to="/pools/invite_code" className="button">Enter Invite Code</Link>
          {this.poolListButton()}
        </div>
      </div>
    } else {
      return <div className='pool-list'>
        <div className='pools'>
          {pools.map(pool => <Pool key={pool.id} pool={pool}/>)}
        </div>
        <div className='actions'>
          {this.poolListButton()}
        </div>
      </div>
    }
  }
}

export default Relay.createContainer(PoolList, {
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
            archived
            tip_off
          }
        }
      }
    `
  }
})
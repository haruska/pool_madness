import React, { Component } from 'react'
import Relay from 'react-relay'
import Tournament from 'components/bracket/tournament'

class Games extends Component {
  render() {
    const tournament = this.props.pool.tournament
    return <div className='games'>
      <h2>{tournament.name}</h2>
      <Tournament tournament={tournament} />
    </div>
  }
}

export default Relay.createContainer(Games, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        tournament {
          name
          ${Tournament.getFragment('tournament')}
        }
      }
    `
  }
})

import React, { Component } from 'react'
import Relay from 'react-relay'

import PoolLayout from 'components/layout/pool'
import Tournament from 'components/bracket/tournament'

class BracketActions extends Component {
  render() {
    const bracket = this.props.bracket
    if (bracket.editable) {
      return <div className="bracket-actions">
        <a href={`/brackets/${bracket.model_id}/edit`}>Edit Bracket</a>
      </div>
    }
    return null
  }
}

class Bracket extends Component {
  title = () => {
    const { bracket } = this.props
    const { owner } = bracket

    if (bracket.name.startsWith(owner.name)) {
      return `${bracket.name}`
    }
    else {
      return `${bracket.name} (${owner.name})`
    }
  }

  render() {
    const { bracket } = this.props
    const pool = bracket.pool
    const tournament = pool.tournament

    return <div className="bracket-details">
      <h2>{this.title()}</h2>
      <BracketActions bracket={bracket}/>
      <Tournament tournament={tournament} bracket={bracket}/>
    </div>
  }
}

export default Relay.createContainer(Bracket, {
  fragments: {
    bracket: () => Relay.QL`
      fragment on Bracket {
        model_id
        name
        tie_breaker
        editable
        owner {
          name
        }  
        pool {
          ${PoolLayout.getFragment('pool')}
          tournament {
            ${Tournament.getFragment('tournament')}
          }
        }
        picks {
          slot
          first_team {
            seed
            name
            still_playing
          }
          second_team {
            seed
            name
            still_playing
          }
          winning_team {
            name
            still_playing
          }  
        }
      }
    `
  }
})
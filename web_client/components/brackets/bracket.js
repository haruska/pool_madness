import React, { Component } from 'react'
import Relay from 'react-relay'
import { Link } from 'react-router'

import PoolLayout from 'components/layout/pool'
import Tournament from 'components/bracket/tournament'

class BracketActions extends Component {
  render() {
    const bracket = this.props.bracket
    if (bracket.editable) {
      return <div className="bracket-actions">
        <Link to={`/brackets/${bracket.model_id}/edit`}>Edit Bracket</Link>
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
        game_decisions
        game_mask
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
      }
    `
  }
})
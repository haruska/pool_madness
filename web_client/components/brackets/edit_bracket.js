import React, { Component } from 'react'
import Relay from 'react-relay'

import { cloneDeep } from 'lodash'

import PoolLayout from 'components/layout/pool'
import Tournament from 'components/bracket/tournament'

class Bracket extends Component {
  constructor(props) {
    super(props)

    this.state = {
      bracket: cloneDeep(props.bracket)
    }
  }

  title = () => {
    const { bracket } = this.props
    const { owner } = bracket

    if (bracket.name.startsWith(owner.name)) {
      return `${bracket.name} Bracket`
    }
    else {
      return `${bracket.name} (${owner.name}) Bracket`
    }
  }

  handleSlotClick = (slotId, choice) => {
    let bracket = cloneDeep(this.state.bracket)
    let gameDecisions = bracket.game_decisions.split('')
    let gameMask = bracket.game_mask.split('')

    gameDecisions[slotId] = choice - 1
    gameMask[slotId] = 1

    bracket.game_decisions = gameDecisions.join('')
    bracket.game_mask = gameMask.join('')

    this.setState({bracket: bracket})
  }

  render() {
    const { bracket } = this.state
    const pool = bracket.pool
    const tournament = pool.tournament

    return <div className="bracket-edit">
      <h2>{this.title()}</h2>
      <Tournament tournament={tournament} bracket={bracket} onSlotClick={this.handleSlotClick}/>
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
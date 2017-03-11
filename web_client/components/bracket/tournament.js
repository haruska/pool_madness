import React, { Component } from 'react'
import Relay from 'react-relay'
import Round from 'components/bracket/round'
import Championship from 'components/bracket/championship'
import RoundsBanner from 'components/bracket/rounds_banner'
import TieBreaker from 'components/bracket/tie_breaker'

class Tournament extends Component {
  render() {
    const { tournament, bracket, onSlotClick, editing, highlightEmpty } = this.props
    const { rounds } = tournament
    const fieldClass = rounds.length >= 6 ? 'field-64' : 'sweet-16'
    const tieBreaker = bracket ? bracket.tie_breaker : null

    return <div className='bracket'>
      <div className={`bracket-heading ${fieldClass}`}>
        <RoundsBanner rounds={rounds} />
      </div>
      <div className={`bracket-body ${fieldClass}`}>
        {rounds.map(r => <Round key={r.number} round={r} tournament={tournament} bracket={bracket} onSlotClick={onSlotClick} highlightEmpty={highlightEmpty} />)}
        <Championship tournament={tournament} bracket={bracket} editing={editing} highlightEmpty={highlightEmpty} />
        <TieBreaker tieBreaker={tieBreaker} editing={editing} />
      </div>
    </div>
  }
}

export default Relay.createContainer(Tournament, {
  fragments: {
    tournament: () => Relay.QL`
      fragment on Tournament {
        rounds {
          name
          number
          start_date
          end_date
          regions
        }
        tip_off
        game_decisions
        game_mask
        teams {
          starting_slot
          seed
          name
        }
      }
    `
  }
})
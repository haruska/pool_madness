import React, { Component } from 'react'
import Relay from 'react-relay'

import Round from 'components/bracket/round'
import Championship from 'components/bracket/championship'
import RoundsBanner from 'components/bracket/rounds_banner'
import TieBreaker from 'components/bracket/tie_breaker'

class Tournament extends Component {
  championshipGame = () => {
    return this.props.tournament.rounds.find(r => r.name == "Champion").games[0]
  }

  championshipPick = () => {
    const bracket = this.props.bracket
    if (bracket && bracket.picks) {
      return bracket.picks.find(pick => pick.slot == 1)
    }
  }

  render() {
    const { tournament, bracket } = this.props
    const { num_rounds, rounds } = tournament
    const fieldClass = num_rounds >= 6 ? 'field-64' : 'sweet-16'

    const picks = bracket ? bracket.picks : null
    const tieBreaker = bracket ? bracket.tie_breaker : null

    return <div className='bracket'>
      <div className={`bracket-heading ${fieldClass}`}>
        <RoundsBanner rounds={rounds} />
      </div>
      <div className={`bracket-body ${fieldClass}`}>
        {rounds.map(r => <Round key={r.number} round={r} picks={picks}/>)}
        <Championship game={this.championshipGame()} pick={this.championshipPick()} />
        <TieBreaker tieBreaker={tieBreaker} />
      </div>
    </div>
  }
}

export default Relay.createContainer(Tournament, {
  fragments: {
    tournament: () => Relay.QL`
      fragment on Tournament {
        num_rounds
        rounds {
          id
          number
          name
          start_date
          end_date
          games {
            slot
            round_number
            region
            winning_team {
              name
            }    
            first_team {
              seed
              name
            }
            second_team {
              seed
              name
            }
          }
        }
      }
    `
  }
})
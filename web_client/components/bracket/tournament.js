import React, { Component } from 'react'
import Relay from 'react-relay'

import Round from 'components/bracket/round'
import Game from 'components/bracket/game'
import Championship from 'components/bracket/championship'
import RoundsBanner from 'components/bracket/rounds_banner'

class Tournament extends Component {
  champion = () => {
    const championship = this.props.tournament.rounds.find(r => r.name == "Champion").games[0]
    const team = championship.winning_team
    if (team) {
      return team.name
    }
    else {
      return null
    }
  }

  render() {
    const { tournament } = this.props
    const { num_rounds, rounds } = tournament
    const fieldClass = num_rounds >= 6 ? 'field-64' : 'sweet-16'

    return <div className='bracket'>
      <div className={`bracket-heading ${fieldClass}`}>
        <RoundsBanner rounds={rounds} />
      </div>
      <div className={`bracket-body ${fieldClass}`}>
        {rounds.map(r => <Round key={r.number} round={r} />)}
        <Championship champion={this.champion()} />
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
            region
            winning_team {
              name
            }
            ${Game.getFragment('game')}
          }
        }
      }
    `
  }
})
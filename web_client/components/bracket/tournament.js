import React, { Component } from 'react'
import Relay from 'react-relay'
import { groupBy } from 'lodash'

import Round from 'components/bracket/round'
import Game from 'components/bracket/game'
import Championship from 'components/bracket/championship'

class Tournament extends Component {
  gamesByRound = () => {
    return groupBy(this.games(), 'round')
  }

  gamesFromRound = (round) => {
    return this.gamesByRound()[round]
  }

  rounds = () => {
    return [...new Set(this.games().map(g => g.round))].sort()
  }

  games = () => {
    return this.props.tournament.games
  }

  champion = () => {
    const maxRound = this.rounds().reverse()[0]
    const team = this.gamesFromRound(maxRound)[0].winning_team
    if (team) {
      return team.name
    }
    else {
      return null
    }
  }

  render() {
    return <div className='bracket'>
      <div className='bracket-body field-64'>
        {this.rounds().map((r, i) => <Round key={r} roundNumber={r} games={this.gamesFromRound(r)} />)}
        <Championship champion={this.champion()} />
      </div>
    </div>
  }
}

export default Relay.createContainer(Tournament, {
  fragments: {
    tournament: () => Relay.QL`
      fragment on Tournament {
        games {
          round
          region
          winning_team {
            name
          }
          ${Game.getFragment('game')}
        }
      }
    `
  }
})
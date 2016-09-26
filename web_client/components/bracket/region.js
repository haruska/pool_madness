import React, { Component } from 'react'
import Round from 'components/bracket/round'
import { groupBy } from 'lodash'

export default class Region extends Component {
  gamesByRound = () => {
    return groupBy(this.props.games, 'round')
  }

  gamesFromRound = (round) => {
    return this.gamesByRound()[round]
  }

  rounds = () => {
    return [...new Set(this.props.games.map(g => g.round))].sort()
  }

  render() {
    const { region, index } = this.props

    return <div className={`region region${index}`}>
      <div className='region-label'>{region}</div>
      {this.rounds().map(r => <Round key={r} roundNumber={r} games={this.gamesFromRound(r)} />)}
    </div>
  }
}

import React, { Component } from 'react'
import Relay from 'react-relay'
import { groupBy } from 'lodash'

import Region from 'components/bracket/region'
import Game from 'components/bracket/game'

class Tournament extends Component {
  gamesByRegion = () => {
    return groupBy(this.props.tournament.games, 'region')
  }

  gamesFromRegion = (region) => {
    return this.gamesByRegion()[region]
  }

  regions = () => {
    return [...new Set(this.props.tournament.games.map(g => g.region))].filter(r => r)
  }

  interRegionGames = () => {
    return this.gamesFromRegion(null)
  }

  render() {
    return <div className='bracket'>
      <div className='bracket-body field-64'>
        {this.regions().map((r, i) => <Region key={`${r}${i}`} index={i+1} region={r} games={this.gamesFromRegion(r)} />)}
        <div className="final-games">
          {this.interRegionGames().map((game, i) => <Game key={i} game={game} index={i} />)}
        </div>
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
          ${Game.getFragment('game')}
        }
      }
    `
  }
})
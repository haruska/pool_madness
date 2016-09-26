import React, { Component } from 'react'
import { values, groupBy } from 'lodash'

import Region from 'components/bracket/region'
import Game from 'components/bracket/game'

export default class Round extends Component {
  gamesByRegion = () => {
    return groupBy(this.props.games, 'region')
  }

  gamesFromRegion = (region) => {
    return this.gamesByRegion()[region]
  }

  regions = () => {
    return [...new Set(this.props.games.map(g => g.region))].filter(r => r)
  }

  interRegionGames = () => {
    const games = this.gamesFromRegion(null)
    if (games) {
      return games.map((game, i) => <Game key={i} game={game} index={i+1} />)
    }
    else {
      return null
    }
  }

  render() {
    const { roundNumber } = this.props
    return <div className={`round round${roundNumber}`}>
      {this.regions().map((r, i) => <Region key={r} index={i+1} games={this.gamesFromRegion(r)} roundNumber={roundNumber} region={r}/>)}
      {this.interRegionGames()}
    </div>
  }
}

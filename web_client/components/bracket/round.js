import React, { Component } from 'react'
import { groupBy } from 'lodash'

import Region from 'components/bracket/region'
import Game from 'components/bracket/game'

export default class Round extends Component {
  games = () => {
    return this.props.round.games
  }
  gamesByRegion = () => {
    return groupBy(this.games(), 'region')
  }

  gamesFromRegion = (region) => {
    return this.gamesByRegion()[region]
  }

  pickForGame = (game) => {
    const picks = this.props.picks
    if (picks) {
      return picks.find(pick => pick.slot == game.slot)
    }
  }

  regions = () => {
    return [...new Set(this.games().map(g => g.region))].filter(r => r)
  }

  interRegionGames = () => {
    const games = this.gamesFromRegion(null)
    if (games) {
      return games.map((game, i) => <Game key={i} game={game} pick={this.pickForGame(game)} index={i+1} />)
    }
    else {
      return null
    }
  }

  render() {
    const { round, picks } = this.props
    return <div className={`round round${round.number}`}>
      {this.regions().map((r, i) => <Region key={r} index={i+1} games={this.gamesFromRegion(r)} picks={picks} roundNumber={round.number} region={r}/>)}
      {this.interRegionGames()}
    </div>
  }
}

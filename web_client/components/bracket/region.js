import React, { Component } from 'react'
import Game from 'components/bracket/game'

export default class Region extends Component {
  pickForGame = (game) => {
    const picks = this.props.picks
    if (picks) {
      return picks.find(pick => pick.slot == game.slot)
    }
  }

  render() {
    const { games, index, region, roundNumber } = this.props
    return <div className={`region region${index}`}>
      {roundNumber == 1 ? <div className={`region-label region${index}`}>{region}</div> : null}
      {games.map((game, i) => <Game key={i} game={game} pick={this.pickForGame(game)} index={i+1} />)}
    </div>
  }
}

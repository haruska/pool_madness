import React, { Component } from 'react'
import Game from 'components/bracket/game'

export default class Region extends Component {
  render() {
    const { games, index, region, roundNumber } = this.props

    return <div className={`region region${index}`}>
      {roundNumber == 1 ? <div className={`region-label region${index}`}>{region}</div> : null}
      {games.map((game, i) => <Game key={i} game={game} index={i+1} />)}
    </div>
  }
}

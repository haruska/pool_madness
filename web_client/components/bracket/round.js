import React, { Component } from 'react'
import { values, groupBy } from 'lodash'

import Game from 'components/bracket/game'

export default class Round extends Component {
  render() {
    const { roundNumber, games } = this.props
    return <div className={`round round${roundNumber}`}>
      {games.map((game, i) => <Game key={i} game={game} index={i} />)}
    </div>
  }
}

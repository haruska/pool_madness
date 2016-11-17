import React, { Component } from 'react'
import Region from 'components/bracket/region'
import Game from 'components/bracket/game'
import { range, chunk } from 'lodash'

export default class Round extends Component {

  gameSlots = () => {
    const { tournament, round } = this.props
    const depth_for = range(1, tournament.rounds.length + 1).reverse().indexOf(round.number) + 1
    if (depth_for == 0) {
      return [1]
    }
    else {
      return range(Math.pow(2, depth_for - 1), Math.pow(2, depth_for))
    }
  }

  gameSlotsByRegion = () => {
    const round = this.props.round
    const gameSlots = this.gameSlots()
    const chunkSize = gameSlots.length / round.regions.length
    return chunk(gameSlots, chunkSize)
  }

  render() {
    const {round, tournament, bracket} = this.props
    if (round.regions) {
      return <div className={`round round${round.number}`}>
        {round.regions.map((r, i) =>
          <Region
            key={i}
            index={i + 1}
            region={r}
            gameSlots={this.gameSlotsByRegion()[i]}
            tournament={tournament}
            bracket={bracket}
            roundNumber={round.number}
          />
        )}
      </div>
    }
    else {
      return <div className={`round round${round.number}`}>
        {this.gameSlots().map((slot, i) =>
          <Game
            key={i}
            index={i + 1}
            slot={slot}
            tournament={tournament}
            bracket={bracket}
          />
        )}
      </div>
    }
  }
}

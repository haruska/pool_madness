import React, { Component } from 'react'
import Game from 'components/bracket/game'

export default class Region extends Component {
  render() {
    const { gameSlots, index, region, roundNumber, tournament, bracket, onSlotClick, highlightEmpty } = this.props
    return <div className={`region region${index}`}>
      {roundNumber == 1 ? <div className={`region-label region${index}`}>{region}</div> : null}
      {gameSlots.map((slot, i) =>
        <Game key={i}
              index={i+1}
              slot={slot}
              tournament={tournament}
              bracket={bracket}
              onSlotClick={onSlotClick}
              highlightEmpty={highlightEmpty}
        />
      )}
    </div>
  }
}

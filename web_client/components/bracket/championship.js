import React, { Component } from 'react'

export default class Championship extends Component {
  championName = () => {
    const { game, pick } = this.props

    const obj = pick || game
    if (obj.winning_team) {
      return obj.winning_team.name
    }
  }

  pickLabel = () => {
    const { game, pick } = this.props
    if (game && pick) {
      if(game.winning_team && pick.winning_team) {
        if(game.winning_team.name == pick.winning_team.name) {
          return 'correct-pick'
        }
        else {
          return 'eliminated'
        }
      }
    }
  }

  render() {
    return <div className="championship">
      <div className={`champion-box ${this.pickLabel()}`.trim()}>{this.championName()}</div>
      <div className="champion-label">CHAMPION</div>
    </div>
  }
}
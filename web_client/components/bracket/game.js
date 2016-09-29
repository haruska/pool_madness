import React, { Component } from 'react'

export default class Game extends Component {
  renderTeam = (game, pick, slot) => {
    let team = null
    let pickClass = ''

    if (slot == 1) {
      if (pick) {
        team = pick.first_team
        const game_team = game.first_team
        if (team && (!team.still_playing || game_team) && game.round_number != 1) {
          if (game_team && team.name == game_team.name) {
            pickClass = 'correct-pick'
          }
          else {
            pickClass = 'eliminated'
          }
        }
      }
      else {
        team = game.first_team
      }
    }
    else { // slot == 2
      if (pick) {
        team = pick.second_team
        const game_team = game.second_team
        if (team && (!team.still_playing || game_team) && game.round_number != 1) {
          if (game_team && team.name == game_team.name) {
            pickClass = 'correct-pick'
          }
          else {
            pickClass = 'eliminated'
          }
        }
      }
      else {
        team = game.second_team
      }
    }

    if (team) {
      return <p className={`slot slot${slot} ${pickClass}`.trim()}><span className="seed">{team.seed}</span> {team.name}
      </p>
    }
    return <p className={`slot slot${slot}`}/>
  }

  render() {
    const {game, index, pick} = this.props

    return <div className={`match m${index}`}>
      {this.renderTeam(game, pick, 1)}
      {this.renderTeam(game, pick, 2)}
    </div>
  }
}
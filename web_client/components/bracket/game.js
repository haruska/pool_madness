import React, { Component } from 'react'
import TournamentTree from 'objects/tournament_tree'
import Team from 'objects/team'

export default class Game extends Component {
  tournamentTree = () => {
    const { rounds, game_decisions, game_mask } = this.props.tournament
    return new TournamentTree(rounds.length, game_decisions, game_mask)
  }

  bracketTree = () => {
    if (this.props.bracket) {
      const { rounds } = this.props.tournament
      const { game_decisions, game_mask } = this.props.bracket
      return new TournamentTree(rounds.length, game_decisions, game_mask)
    }
    else {
      return null
    }
  }

  teamByStartingSlot = (slot) => {
    if (slot) {
      return new Team(this.props.tournament, this.tournamentTree(), slot)
    }
    return null
  }

  renderTeam = (game, pick, slot) => {
    let team = null
    let pickClass = ''
    if (slot == 1) {
      if (pick) {
        team = this.teamByStartingSlot(pick.firstTeamStartingSlot())
        const game_team = this.teamByStartingSlot(game.firstTeamStartingSlot())
        if (team && (!team.stillPlaying() || game_team) && !game.isRoundOne()) {
          if (game_team && team.name == game_team.name) {
            pickClass = 'correct-pick'
          }
          else {
            pickClass = 'eliminated'
          }
        }
      }
      else {
        team = this.teamByStartingSlot(game.firstTeamStartingSlot())
      }
    }
    else { // slot == 2
      if (pick) {
        team = this.teamByStartingSlot(pick.secondTeamStartingSlot())
        const game_team = this.teamByStartingSlot(game.secondTeamStartingSlot())
        if (team && (!team.stillPlaying() || game_team) && !game.isRoundOne()) {
          if (game_team && team.name == game_team.name) {
            pickClass = 'correct-pick'
          }
          else {
            pickClass = 'eliminated'
          }
        }
      }
      else {
        team = this.teamByStartingSlot(game.secondTeamStartingSlot())
      }
    }

    if (team) {
      return <p className={`slot slot${slot} ${pickClass}`.trim()}><span className="seed">{team.seed}</span> {team.name}
      </p>
    }
    return <p className={`slot slot${slot}`}/>
  }

  render() {
    const { index, slot } = this.props
    const game = this.tournamentTree().gameNodes[slot]
    const bracketTree = this.bracketTree()
    const pick = bracketTree ? bracketTree.gameNodes[slot] : null
    return <div className={`match m${index}`}>
      {this.renderTeam(game, pick, 1)}
      {this.renderTeam(game, pick, 2)}
    </div>
  }
}
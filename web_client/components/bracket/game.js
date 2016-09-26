import React, { Component } from 'react'
import Relay from 'react-relay'

class Game extends Component {
  renderTeam = (team, slot) => {
    if(team) {
      return <p className={`slot slot${slot}`}><span className="seed">{team.seed}</span> {team.name}</p>
    }
    return <p className={`slot slot${slot}`}/>
  }

  render() {
    const { game, index } = this.props
    return <div className={`match m${index}`}>
      {this.renderTeam(game.first_team, 1)}
      {this.renderTeam(game.second_team, 2)}
    </div>
  }
}

export default Relay.createContainer(Game, {
  fragments: {
    game: () => Relay.QL`
      fragment on Game {
        first_team {
          seed
          name
        }
        second_team {
          seed
          name
        }
      }
    `
  }
})
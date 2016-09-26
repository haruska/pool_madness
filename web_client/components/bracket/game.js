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
    return <div className={`match match${index}`}>
      {this.renderTeam(game.team_one, 1)}
      {this.renderTeam(game.team_two, 2)}
    </div>
  }
}

export default Relay.createContainer(Game, {
  fragments: {
    game: () => Relay.QL`
      fragment on Game {
        team_one {
          seed
          name
        }
        team_two {
          seed
          name
        }
      }
    `
  }
})
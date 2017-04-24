import React, { Component } from 'react'
import Relay from 'react-relay'
import { times } from 'lodash'
import fibonacci from 'utils/fibonacci'
import { ordinalInWord } from 'utils/ordinals'

class ScoreRow extends Component {
  render () {
    let {round} = this.props

    return <tr>
      <td>{ordinalInWord(round)}</td>
      <td>{fibonacci(round + 1)} + Seed Number</td>
    </tr>
  }
}

class Scoring extends Component {
  render () {
    let { pool } = this.props

    return <div className='pool-scoring'>
      <h3>Scoring</h3>
      <table>
        <thead>
          <tr>
            <th>Round</th>
            <th>Points per Game</th>
          </tr>
        </thead>
        <tbody>
          {times(pool.tournament.rounds.length, i => <ScoreRow key={i} round={i + 1} />)}
        </tbody>
      </table>
      <div>
        For all correct picks you get that round's points <em>plus</em>
        the seed number of the team. So, if you pick the 10th-seed
        team to win the 3rd-round, that would be 13 points if correct.
      </div>

      <h3>Tie Breaker</h3>
      <div>
        In case of a tie will broken in the following order
      </div>
      <ol>
        <li>Closest "tiebreaker" to the total score (both teams) added together in the final game</li>
        <li>Correct team picked for winner</li>
        <li>Correct overall number of picks</li>
      </ol>
      <div>
        If two brackets are still tied after this, they split the winnings.
      </div>
    </div>
  }
}

export default Relay.createContainer(Scoring, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        tournament {
          rounds {
            id
          }
        }
      }
    `
  }
})

import React, { Component } from 'react'
import Relay from 'react-relay'
import { ordinalInWord } from 'utils/ordinals'

class PrizeRow extends Component {
  render() {
    const {pool, place, percent} = this.props

    return <tr>
      <td>{ordinalInWord(place)} Place</td>
      <td>{Math.round(percent * 100)}%</td>
      {pool.started ? <td>${Math.floor(pool.total_collected * percent)}</td> : false}
    </tr>
  }
}

class Prizes extends Component {
  render() {
    let { pool } = this.props

    return <div className="pool-prizes">
      <h3>Prizes</h3>
      <table>
        <tbody>
          {[0.7, 0.2, 0.1].map((percent, i) => <PrizeRow key={`prizerow-${i}`} pool={pool} place={i+1} percent={percent}/>)}
        </tbody>
      </table>
    </div>
  }
}

export default Relay.createContainer(Prizes, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        started
        total_collected
      }
    `
  }
})

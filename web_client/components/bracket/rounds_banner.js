import React, { Component } from 'react'
import moment from 'moment'

export default class RoundsBanner extends Component {
  dateRangeString = (start, end) => {
    const startDate = moment(start)
    const endDate = moment(end)
    let dateStr = startDate.format('MMM D')

    if (endDate > startDate) {
      dateStr += `-${endDate.format('D')}`
    }

    return dateStr
  }

  render() {
    let reverseRounds = Array.from(this.props.rounds).reverse()
    reverseRounds.shift()

    let rounds = this.props.rounds.concat(reverseRounds)

    return <table className="gridtable">
      <tbody>
        <tr>
          {rounds.map((r, i) => <th key={i}>{r.name}</th>)}
        </tr>
        <tr>
          {rounds.map((r, i) => <td key={i}>{this.dateRangeString(r.start_date, r.end_date)}</td>)}
        </tr>
      </tbody>
    </table>
  }
}

import React from 'react'
import Relay from 'react-relay'
import moment from 'moment-timezone'

let Component = React.createClass({
  formattedTipOffTime() {
    let tipOff = moment(this.props.pool.tournament.tip_off).tz("America/New_York")
    return `${tipOff.format("dddd	MMMM D, Y")} at ${tipOff.format("h:mma z")}`
  },

  render() {
    let { pool } = this.props

    return <div className="pool-settings">
      <h3 className="first">Pool Settings</h3>
      <table>
        <tbody>
          <tr>
            <td>Entry Amount</td>
            <td>${pool.entry_fee / 100}</td>
          </tr>
          <tr>
            <td>Tiebreaker</td>
            <td>Points in final game</td>
          </tr>
          <tr>
            <td>Seed reward?</td>
            <td>Yes</td>
          </tr>
          <tr>
            <td>Entry Deadline</td>
            <td>{this.formattedTipOffTime()}</td>
          </tr>
        </tbody>
      </table>
    </div>
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        entry_fee
        tournament {
          tip_off
        }
      }
    `
  }
})

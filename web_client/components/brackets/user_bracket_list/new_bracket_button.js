import React, { Component } from 'react'

export default class NewBracketButton extends Component {
  render() {
    const { poolId, bracketCount } = this.props
    let button

    if (bracketCount > 0) {
      button = <button className="minor">Another Bracket Entry</button>
    } else {
      button = <button>New Bracket Entry</button>
    }

    return <form method="post" action={`/pools/${poolId}/brackets`}>
      {button}
    </form>
  }
}

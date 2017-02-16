import React, { Component } from 'react'

export default class TieBreaker extends Component {
  render() {
    if (this.props.tieBreaker && !this.props.editing) {
      return <div className="tie-breaker">
        Tie Breaker:
        <span className="tie-breaker-value"> {this.props.tieBreaker}</span>
      </div>
    }
    return null
  }
}
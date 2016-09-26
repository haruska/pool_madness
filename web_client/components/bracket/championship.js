import React, { Component } from 'react'

export default class Championship extends Component {
  render() {
    return <div className="championship">
      <div className="champion-box">{this.props.champion}</div>
      <div className="champion-label">CHAMPION</div>
    </div>
  }
}
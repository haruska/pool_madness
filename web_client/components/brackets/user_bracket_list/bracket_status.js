import React, { Component } from 'react'

export default class BracketStatus extends Component {
  render() {
    const { status } = this.props

    switch (status) {
      case 'ok':
        return <span className="badge-success">OK</span>
      case 'unpaid':
        return <span className="badge-alert">Unpaid</span>
      case 'incomplete':
        return <span className="badge-error">Incomplete</span>
      default:
        return <span>Unknown</span>
    }
  }
}

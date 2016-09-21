import React, { Component } from 'react'

export default class TableHeader extends Component {
  render() {
    const { bracketCount } = this.props

    if (bracketCount > 0) {
      let headings = ['Name', 'Final Four', 'Final Four', 'Second', 'Winner', 'Tie', 'Status']
      return <thead>
      <tr>
        {headings.map((heading, i) => <th key={`heading-${i}`}>{heading}</th>)}
      </tr>
      </thead>
    } else {
      return false
    }
  }
}
import React, { Component } from 'react'

export default class TableHeader extends Component {
  render () {
    const { showEliminated } = this.props

    var headings

    if (showEliminated) {
      headings = ['', 'Name', 'Score', 'Possible', 'Best', 'Final Four', 'Final Four', 'Second', 'Winner']
    } else {
      headings = ['', 'Name', 'Score', 'Possible', 'Final Four', 'Final Four', 'Second', 'Winner']
    }

    return <thead>
      <tr>
        {headings.map((heading, i) => <th key={`heading-${i}`}>{heading}</th>)}
      </tr>
    </thead>
  }
}

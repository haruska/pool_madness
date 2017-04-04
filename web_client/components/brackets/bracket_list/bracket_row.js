import React, { Component } from 'react'
import { Link } from 'react-router'

class BestPossible extends Component {
  render() {
    const {showEliminated, bracket} = this.props
    return showEliminated ? <td className="best-possible">{bracket.best_possible_finish}</td> : false
  }
}

export default class BracketRow extends Component {
  truncatedBracketName = (maxSize) => {
    maxSize = maxSize || 25
    const bracketName = this.props.bracket.name

    if (bracketName.length < maxSize) {
      return bracketName
    }

    const subString = bracketName.substr(0, maxSize-1)
    const onWordBoundry = subString.substr(0, subString.lastIndexOf(' '))

    const truncatedName = onWordBoundry === '' ? subString : onWordBoundry

    return truncatedName + '...'
  }

  render() {
    const { bracket, index, showEliminated, viewer, tied } = this.props
    const { current_user } = viewer
    const finalFourTeams = bracket.final_four
    const bracketPath = `/brackets/${bracket.model_id}`

    let place = `${index}.`
    if (tied) {
      place = `T${place}`
    }
    if (showEliminated && bracket.eliminated) {
      place = `* ${place}`
    }

    let rowClass = `bracket-row bracket-${bracket.model_id}`
    if (bracket.owner.model_id == current_user.model_id) {
      rowClass += " current-user-bracket"
    }

    return <tr className={rowClass}>
      <td className="position">{place}</td>
      <td className="name"><Link to={bracketPath}>{this.truncatedBracketName()}</Link></td>
      <td className="points">{bracket.points}</td>
      <td className="possible">{bracket.possible_points}</td>
      <BestPossible {...this.props}/>
      {finalFourTeams.map(team => <td key={team.id} className="final-four-team">{team.name}</td>)}
    </tr>
  }
}
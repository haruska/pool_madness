import React, { Component } from 'react'
import { Link } from 'react-router'

class BestPossible extends Component {
  render() {
    const {showEliminated, bracket} = this.props
    return showEliminated ? <td className="best-possible">{bracket.best_possible_finish}</td> : false
  }
}

export default class BracketRow extends Component {
  render() {
    const { bracket, index, showEliminated, viewer } = this.props
    const { current_user } = viewer
    const finalFourTeams = bracket.final_four
    const bracketPath = `/brackets/${bracket.model_id}`

    var place = `${index}.`
    if (showEliminated && bracket.eliminated) {
      place = `* ${place}`
    }

    var rowClass = `bracket-row bracket-${bracket.model_id}`
    if (bracket.owner.model_id == current_user.model_id) {
      rowClass += " current-user-bracket"
    }

    return <tr className={rowClass}>
      <td className="position">{place}</td>
      <td className="name"><Link to={bracketPath}>{bracket.name}</Link></td>
      <td className="points">{bracket.points}</td>
      <td className="possible">{bracket.possible_points}</td>
      <BestPossible {...this.props}/>
      {finalFourTeams.map(team => <td key={team.id} className="final-four-team">{team.name}</td>)}
    </tr>
  }
}
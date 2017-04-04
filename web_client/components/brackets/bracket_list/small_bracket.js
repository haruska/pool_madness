import React, { Component } from 'react'
import { Link } from 'react-router'

class BestPossible extends Component {
  render() {
    const { showEliminated, bracket } = this.props

    if (showEliminated) {
      let bestPossible = bracket.eliminated ? "eliminated" : `possible ${bracket.best_possible_finish} place finish`
      return <div className="best-possible">{bestPossible}</div>
    } else {
      return false
    }
  }
}

export default class SmallBracket extends Component {
  render() {
    const { bracket, showEliminated, index, viewer, tied } = this.props
    const { current_user } = viewer
    const finalFourTeams = bracket.final_four
    const bracketName = showEliminated && bracket.eliminated ? `* ${bracket.name}` : bracket.name
    const bracketPath = `/brackets/${bracket.model_id}`

    let place = `${index}.`
    if (tied) {
      place = `T${place}`
    }

    var rowClass = `bracket-row bracket-${bracket.model_id}`
    if (bracket.owner.model_id == current_user.model_id) {
      rowClass += " current-user-bracket"
    }

    return <Link to={bracketPath}>
      <div className={rowClass}>
        <div className='bracket-attributes'>
          <div className='position'>{place}</div>
          <div className='bracket-details'>
            <div className="name">{bracketName}</div>
            <div className="points">
              <div className="total">{bracket.points}</div>
              <div className="possible">{bracket.possible_points}</div>
            </div>
            <BestPossible {...this.props}/>
            <div className="final-four-teams">
              {finalFourTeams.map((team, i) =>
                <div key={team.id} className={`final-four-team final-four-team${i}`}>
                  {team.name}
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </Link>
  }
}

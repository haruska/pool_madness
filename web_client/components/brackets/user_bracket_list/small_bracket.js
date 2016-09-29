import React, { Component } from 'react'
import { Link } from 'react-router'
import BracketStatus from './bracket_status'
import { times } from 'lodash'

export default class SmallBracket extends Component {
  render() {
    const { bracket } = this.props
    const finalFourTeams = bracket.final_four
    const bracketPath = `/brackets/${bracket.model_id}`
    const emptyTeamsSize = 4 - finalFourTeams.length

    return <Link to={bracketPath}>
      <div className='bracket-row'>
        <div className='bracket-attributes'>
          <div className='position'>&nbsp;</div>
          <div className='bracket-details'>
            <div className="name">{bracket.name}</div>
            <div className="final-four-teams">
              {finalFourTeams.map((team, i) =>
                <div key={team.id} className={`final-four-team final-four-team${i}`}>
                  {team.name}
                </div>
              )}
              {times(emptyTeamsSize, x => <div className='bracket-final-four' key={`bracket-${bracket.id}-empty-${x}`}/>)}
            </div>
            <div className="tie-breaker">{bracket.tie_breaker}</div>
            <div className="status"><BracketStatus status={bracket.status}/></div>
          </div>
        </div>
      </div>
    </Link>
  }
}
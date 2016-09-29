import React, { Component } from 'react'
import { Link } from 'react-router'
import BracketStatus from './bracket_status'
import { times } from 'lodash'

export default class BracketRow extends Component {
  render() {
    const { bracket } = this.props
    const finalFourTeams = bracket.final_four
    const bracketPath = `/brackets/${bracket.model_id}`
    const emptyTeamsSize = 4 - finalFourTeams.length

    return <tr className={`bracket-row bracket-${bracket.model_id}`}>
      <td className='bracket-name'><Link to={bracketPath}>{bracket.name}</Link></td>
      {finalFourTeams.map(team => <td className='bracket-final-four' key={team.id}>{team.name}</td>)}
      {times(emptyTeamsSize, x => <td className='bracket-final-four' key={`bracket-${bracket.id}-empty-${x}`}>&nbsp;</td>)}
      <td className='bracket-tie-breaker'>{bracket.tie_breaker}</td>
      <td className='bracket-status'><BracketStatus status={bracket.status}/></td>
    </tr>
  }
}
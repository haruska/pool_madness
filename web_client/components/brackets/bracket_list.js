import React from 'react'
import Relay from 'react-relay'

function TeamName(props) {
  return <td>{props.team.name}</td>
}

function Bracket(props) {
  let bracket = props.bracket
  let finalFourTeams = bracket.final_four.edges.map(edge => edge.node)
  let bracketPath = `/brackets/${bracket.model_id}`

  return <tr className='bracket-row'>
    <td>{props.index}.</td>
    <td><a href={bracketPath}>{bracket.name}</a></td>
    <td>{bracket.points}</td>
    <td>{bracket.possible_points}</td>
    <td>{bracket.best_possible_finish}</td>
    {finalFourTeams.map(team => <TeamName key={team.id} team={team}/>)}
  </tr>
}

var Component = React.createClass({
  contextTypes: {
    setPageTitle: React.PropTypes.func.isRequired
  },

  componentWillMount() {
    this.context.setPageTitle("Brackets")
  },

  componentWillUnmount() {
    this.context.setPageTitle()
  },

  render() {
    let brackets = this.props.pool.brackets.edges.map(edge => edge.node)

    return <div className='bracket-list large-screen'>
      <table className='tables'>
        <thead>
        <tr>
          <th></th>
          <th>Name</th>
          <th>Score</th>
          <th>Possible</th>
          <th>Best</th>
          <th>Final Four</th>
          <th>Final Four</th>
          <th>Second</th>
          <th>Winner</th>
        </tr>
        </thead>
        <tbody>
          {brackets.map((bracket, i) => <Bracket key={bracket.id} index={i+1} bracket={bracket}/>)}
        </tbody>
      </table>
    </div>
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        brackets(first: 1000) {
          edges {
            node {
              id
              model_id
              name
              points
              possible_points
              best_possible_finish
              tie_breaker
              final_four(first: 4) {
                edges {
                  node {
                    id
                    name
                  }
                }
              }
            }
          }
        }
      }
    `
  }
})
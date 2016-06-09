import React from 'react'
import Relay from 'react-relay'
import { times } from 'lodash'

function TableHeader() {
  let headings = ['Name', 'Final Four', 'Final Four', 'Second', 'Winner', 'Tie', 'Status']
  return <thead>
  <tr>
    { headings.map((heading, i) => <th key={`heading-${i}`}>{heading}</th>) }
  </tr>
  </thead>
}

function BracketStatus(props) {
  switch(props.status) {
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

function BracketRow(props) {
  let bracket = props.bracket
  let finalFourTeams = bracket.final_four.edges.map(edge => edge.node)
  let bracketPath = `/brackets/${bracket.model_id}`
  let emptyTeamsSize = 4 - finalFourTeams.length

  return <tr className='bracket-row'>
    <td><a href={bracketPath}>{bracket.name}</a></td>
    {finalFourTeams.map(team => <td key={team.id}>{team.name}</td>)}
    { times(emptyTeamsSize, x => <td key={`bracket-${bracket.id}-empty-${x}`}></td>) }
    <td>{bracket.tie_breaker}</td>
    <td><BracketStatus status={bracket.status} /></td>
  </tr>
}

var Component = React.createClass({
  contextTypes: {
    setPageTitle: React.PropTypes.func.isRequired
  },

  componentWillMount() {
    this.context.setPageTitle("My Brackets")
  },

  componentWillUnmount() {
    this.context.setPageTitle()
  },

  brackets() {
    return this.props.pool.brackets.edges.map(edge => edge.node)
  },

  render() {
    let brackets = this.brackets()

    return <div className='user-bracket-list'>
      <div className='large-screen'>
        <table className='table-minimal'>
          <TableHeader />
          <tbody>
          {brackets.map(bracket => <BracketRow key={bracket.id} bracket={bracket} />)}
          </tbody>
        </table>
      </div>
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
              tie_breaker
              status
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
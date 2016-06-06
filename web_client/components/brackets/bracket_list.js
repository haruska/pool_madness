import React from 'react'
import Relay from 'react-relay'



function TeamName(props) {
  if (props.smallScreen) {
    return <div className={`final-four-team final-four-team${props.index}`}>{props.team.name}</div>
  }
  else {
    return <td>{props.team.name}</td>
  }
}

function SmallBracket(props) {
  let bracket = props.bracket
  let bracketName = props.displayBest && bracket.eliminated ? `* ${bracket.name}` : bracket.name
  let finalFourTeams = bracket.final_four.edges.map(edge => edge.node)

  function DisplayBest(props) {
    if (props.displayBest) {
      let bracket = props.bracket
      let bestPossible = bracket.eliminated ? "eliminated" : `possible ${bracket.best_possible_finish} place finish`
      return <div className="best-possible">{bestPossible}</div>
    }
    else {
      return false
    }
  }

  return <a href={`/brackets/${bracket.model_id}`}>
    <div className='bracket-row'>
      <div className='bracket-attributes'>
        <div className='position'>{props.index}.</div>
        <div className='bracket-details'>
          <div className="name">{bracketName}</div>
          <div className="points">
            <div className="total">{bracket.points}</div>
            <div className="possible">{bracket.possible_points}</div>
          </div>
          <DisplayBest {...props} />
          <div className="final-four-teams">
            {finalFourTeams.map((team, i) => <TeamName key={team.id} team={team} index={i} smallScreen={true}/>)}
          </div>
        </div>
      </div>
    </div>
  </a>
}


function BracketRow(props) {
  let bracket = props.bracket
  let finalFourTeams = bracket.final_four.edges.map(edge => edge.node)
  let bracketPath = `/brackets/${bracket.model_id}`
  var place = `${props.index}.`

  if (props.displayBest && bracket.eliminated) {
    place = '* ' + place
  }

  const DisplayBest = props => props.displayBest ? <td>{props.bracket.best_possible_finish}</td> : false

  return <tr className='bracket-row'>
    <td>{place}</td>
    <td><a href={bracketPath}>{bracket.name}</a></td>
    <td>{bracket.points}</td>
    <td>{bracket.possible_points}</td>
    <DisplayBest {...props} />
    {finalFourTeams.map(team => <TeamName key={team.id} team={team}/>)}
  </tr>
}

function TableHeader(props) {
  var headings = ['', 'Name', 'Score', 'Possible', 'Best', 'Final Four', 'Final Four', 'Second', 'Winner']

  if (!props.pool.display_best) {
    headings = headings.filter(heading => heading != 'Best' )
  }

  return <thead>
  <tr>
    { headings.map(heading => <th>{heading}</th>) }
  </tr>
  </thead>
}

var Component = React.createClass({
  contextTypes: {
    setPageTitle: React.PropTypes.func.isRequired
  },

  componentWillMount() {
    this.context.setPageTitle('Brackets')
  },

  componentDidMount() {
    let brackets = this.props.pool.brackets.edges.map(edge => edge.node)
    this.context.setPageTitle(`Brackets (${brackets.length} total)`)
  },

  componentWillUnmount() {
    this.context.setPageTitle()
  },

  render() {
    let pool = this.props.pool

    let brackets = pool.brackets.edges.map(edge => edge.node)

    return <div className='bracket-list'>
      <div className='large-screen'>
        <table className='tables'>
          <TableHeader pool={pool}/>
          <tbody>
          {brackets.map((bracket, i) => <BracketRow key={bracket.id} index={i+1} bracket={bracket} displayBest={pool.display_best}/>)}
          </tbody>
        </table>
      </div>

      <div className='small-screen'>
        {brackets.map((bracket, i) => <SmallBracket key={bracket.id} index={i+1} bracket={bracket} displayBest={pool.display_best}/>)}
      </div>
    </div>
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        display_best
        brackets(first: 1000) {
          edges {
            node {
              id
              model_id
              name
              points
              possible_points
              best_possible_finish
              eliminated
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
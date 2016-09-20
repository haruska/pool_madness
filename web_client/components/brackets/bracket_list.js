import React from 'react'
import Relay from 'react-relay'

var Component = React.createClass({
  contextTypes: {
    setPageTitle: React.PropTypes.func.isRequired
  },

  componentWillMount() {
    this.context.setPageTitle(`Brackets (${this.brackets().length} total)`)
  },

  componentWillUnmount() {
    this.context.setPageTitle()
  },

  brackets() {
    return this.props.pool.brackets.edges.map(edge => edge.node)
  },
  
  showEliminated() {
    return this.props.pool.display_best
  },

  TableHeader() {
    var headings;

    if(this.showEliminated()) {
      headings = ['', 'Name', 'Score', 'Possible', 'Best', 'Final Four', 'Final Four', 'Second', 'Winner']
    } else {
      headings = ['', 'Name', 'Score', 'Possible', 'Final Four', 'Final Four', 'Second', 'Winner']
    }

    return <thead>
      <tr>
        {headings.map((heading, i) => <th key={`heading-${i}`}>{heading}</th>)}
      </tr>
    </thead>
  },

  BracketRow(props) {
    let bracket = props.bracket
    let finalFourTeams = bracket.final_four
    let bracketPath = `/brackets/${bracket.model_id}`

    var place = `${props.index}.`
    if (this.showEliminated() && bracket.eliminated) { place = `* ${place}` }

    function BestPossible(props) {
      return props.showEliminated ? <td className="best-possible">{bracket.best_possible_finish}</td> : false
    }

    var rowClass = `bracket-row bracket-${bracket.model_id}`
    if (bracket.owner.model_id == this.props.current_user.model_id) {
      rowClass += " current-user-bracket"
    }

    return <tr className={rowClass}>
      <td className="position">{place}</td>
      <td className="name"><a href={bracketPath}>{bracket.name}</a></td>
      <td className="points">{bracket.points}</td>
      <td className="possible">{bracket.possible_points}</td>
      <BestPossible {...this.props} showEliminated={this.showEliminated()} />
      {finalFourTeams.map(team => <td key={team.id} className="final-four-team">{team.name}</td>)}
    </tr>
  },

  SmallBracket(props) {
    let bracket = props.bracket
    let finalFourTeams = bracket.final_four
    let bracketName = this.showEliminated() && bracket.eliminated ? `* ${bracket.name}` : bracket.name
    let bracketPath = `/brackets/${bracket.model_id}`
    var place = `${props.index}.`

    function BestPossible(props) {
      if (props.showEliminated) {
        let bestPossible = bracket.eliminated ? "eliminated" :  `possible ${bracket.best_possible_finish} place finish`
        return <div className="best-possible">{bestPossible}</div>
      } else {
        return false
      }
    }

    var rowClass = `bracket-row bracket-${bracket.model_id}`
    if (bracket.owner.model_id == this.props.current_user.model_id) {
      rowClass += " current-user-bracket"
    }

    return <a href={bracketPath}>
      <div className={rowClass}>
        <div className='bracket-attributes'>
          <div className='position'>{place}</div>
          <div className='bracket-details'>
            <div className="name">{bracketName}</div>
            <div className="points">
              <div className="total">{bracket.points}</div>
              <div className="possible">{bracket.possible_points}</div>
            </div>
            <BestPossible {...this.props} showEliminated={this.showEliminated()} />
            <div className="final-four-teams">
              {finalFourTeams.map((team, i) => <div key={team.id} className={`final-four-team final-four-team${i}`}>{team.name}</div>)}
            </div>
          </div>
        </div>
      </div>
    </a>
  },

  render() {
    let TableHeader = this.TableHeader
    let BracketRow = this.BracketRow
    let SmallBracket = this.SmallBracket

    let brackets = this.brackets()

    return <div className='bracket-list'>
      <div className='large-screen'>
        <table className='tables'>
          <TableHeader />
          <tbody>
            {brackets.map((bracket, i) => <BracketRow key={bracket.id} index={i+1} bracket={bracket} />)}
          </tbody>
        </table>
      </div>

      <div className='small-screen'>
        {brackets.map((bracket, i) => <SmallBracket key={bracket.id} index={i+1} bracket={bracket} />)}
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
              final_four {
                id
                name
              }
              owner {
                model_id
              }
            }
          }
        }
      }
    `,
    current_user: () => Relay.QL`
      fragment on CurrentUser {
        model_id
      }
    `
  }
})
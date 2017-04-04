import React, { Component } from 'react'
import Relay from 'react-relay'
import moment from 'moment'
import TableHeader from './bracket_list/table_header'
import BracketRow from './bracket_list/bracket_row'
import SmallBracket from './bracket_list/small_bracket'

class BracketList extends Component {
  static contextTypes = {
    setPageTitle: React.PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)
    this.state = {lastUpdate: null}
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  componentWillMount() {
    this.context.setPageTitle(`Brackets (${this.props.pool.bracket_count} total)`)
  }
  componentDidMount() {
    this.updateData()
  }

  updateData = () => {
    const {lastUpdate} = this.state
    const {relay, pool} = this.props

    if (lastUpdate) {
      if (moment().subtract(10, 'seconds').isAfter(lastUpdate)) {
        relay.forceFetch()
        this.setState({lastUpdate: moment()})
      }
    }
    else {
      relay.setVariables({bracketSize: pool.bracket_count})
      this.setState({lastUpdate: moment()})
    }
  }

  handleRefresh = () => {
    this.updateData()
  }

  brackets = () => {
    return this.props.pool.brackets.edges.map(edge => edge.node)
  }

  bracketsWithPlace = () => {
    let brackets = this.brackets()
    let placeBrackets = {}

    let currentPlace = 1
    brackets.forEach((b, i) => {
      if(i != 0 && b.points != brackets[i-1].points) {
        currentPlace = i+1
      }
      placeBrackets[currentPlace] = placeBrackets[currentPlace] || []
      placeBrackets[currentPlace].push(b)
    })

    return placeBrackets
  }

  showEliminated = () => {
    return this.props.pool.display_best
  }



  render() {
    const { viewer } = this.props
    const bracketsWithPlace = this.bracketsWithPlace()

    return <div className='bracket-list'>
      <div className='refresh-wrapper'>
        <div className='refresh-time'>
          Last updated {this.state.lastUpdate && this.state.lastUpdate.format('h:mm a')}
        </div>
        <div className='refresh-link'>
          [<a onClick={this.handleRefresh}>Refresh</a>]
        </div>
      </div>
      <div className='large-screen'>

        <table className='tables'>
          <TableHeader showEliminated={this.showEliminated()}/>
          <tbody>
          {
            Object.keys(bracketsWithPlace).map(place =>
              bracketsWithPlace[place].map(bracket =>
                <BracketRow
                  key={bracket.id}
                  index={place}
                  tied={bracketsWithPlace[place].length > 1}
                  bracket={bracket}
                  showEliminated={this.showEliminated()}
                  viewer={viewer}
                />
              )
            ).reduce((acc, val) => acc.concat(val), [])
          }
          </tbody>
        </table>
      </div>

      <div className='small-screen'>
        {
          Object.keys(bracketsWithPlace).map(place =>
            bracketsWithPlace[place].map(bracket =>
              <SmallBracket
                key={bracket.id}
                index={place}
                tied={bracketsWithPlace[place].length > 1}
                bracket={bracket}
                showEliminated={this.showEliminated()}
                viewer={viewer}
              />
            )
          ).reduce((acc, val) => acc.concat(val), [])
        }
      </div>
    </div>
  }
}

export default Relay.createContainer(BracketList, {
  initialVariables: {bracketSize: 30},
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        display_best
        bracket_count
        brackets(first: $bracketSize) {
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
    viewer: () => Relay.QL`
      fragment on Viewer {
        current_user {
          model_id
        }
      }
    `
  }
})
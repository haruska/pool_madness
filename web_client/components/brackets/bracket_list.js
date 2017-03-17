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


  componentWillMount() {
    this.context.setPageTitle(`Brackets (${this.brackets().length} total)`)
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  componentDidMount() {
    this.updateData()
  }

  updateData = () => {
    const {lastUpdate} = this.state
    if (lastUpdate) {
      if (moment().subtract(10, 'seconds').isAfter(lastUpdate)) {
        this.props.relay.forceFetch()
        this.setState({lastUpdate: moment()})
      }
    }
    else {
      this.setState({lastUpdate: moment()})
    }
  }

  handleRefresh = () => {
    this.updateData()
  }

  brackets = () => {
    return this.props.pool.brackets.edges.map(edge => edge.node)
  }

  showEliminated = () => {
    return this.props.pool.display_best
  }

  render() {
    const { viewer } = this.props
    const brackets = this.brackets()

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
            {brackets.map((bracket, i) =>
              <BracketRow
                key={bracket.id}
                index={i+1}
                bracket={bracket}
                showEliminated={this.showEliminated()}
                viewer={viewer}
              />
            )}
          </tbody>
        </table>
      </div>

      <div className='small-screen'>
        {brackets.map((bracket, i) =>
          <SmallBracket
            key={bracket.id}
            index={i+1}
            bracket={bracket}
            showEliminated={this.showEliminated()}
            viewer={viewer}
          />
        )}
      </div>
    </div>
  }
}

export default Relay.createContainer(BracketList, {
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
    viewer: () => Relay.QL`
      fragment on Viewer {
        current_user {
          model_id
        }
      }
    `
  }
})
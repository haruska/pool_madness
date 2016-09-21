import React, { Component } from 'react'
import Relay from 'react-relay'

import TableHeader from './bracket_list/table_header'
import BracketRow from './bracket_list/bracket_row'
import SmallBracket from './bracket_list/small_bracket'

class BracketList extends Component {
  static contextTypes = {
    setPageTitle: React.PropTypes.func.isRequired
  }

  componentWillMount() {
    this.context.setPageTitle(`Brackets (${this.brackets().length} total)`)
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  brackets = () => {
    return this.props.pool.brackets.edges.map(edge => edge.node)
  }

  showEliminated = () => {
    return this.props.pool.display_best
  }

  render() {
    const { current_user } = this.props
    const brackets = this.brackets()

    return <div className='bracket-list'>
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
              current_user={current_user}
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
            current_user={current_user}
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
    current_user: () => Relay.QL`
      fragment on CurrentUser {
        model_id
      }
    `
  }
})
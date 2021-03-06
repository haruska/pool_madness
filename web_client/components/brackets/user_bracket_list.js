import React, { Component } from 'react'
import Relay from 'react-relay'

import PaymentButton from 'components/payments/payment_button'
import TableHeader from './user_bracket_list/table_header'
import BracketRow from './user_bracket_list/bracket_row'
import SmallBracket from './user_bracket_list/small_bracket'
import NewBracketButton from './user_bracket_list/new_bracket_button'

class UserBracketList extends Component {
  static contextTypes = {
    setPageTitle: React.PropTypes.func.isRequired,
    router: React.PropTypes.object.isRequired
  }

  state = {
    generatingBracket: false
  }

  componentWillMount () {
    this.context.setPageTitle('My Brackets')

    const { started, model_id } = this.props.pool
    if (started) {
      this.context.router.replace(`/pools/${model_id}/brackets`) // eslint-disable-line
    }
  }

  componentWillUnmount () {
    this.context.setPageTitle()
  }

  brackets = () => {
    return this.props.pool.brackets.edges.map(edge => edge.node)
  }

  unpaidBrackets = () => {
    return this.brackets().filter(bracket => bracket.status === 'unpaid')
  }

  trackNewBracketClick = () => {
    this.setState({generatingBracket: true})
  }

  shouldComponentUpdate (nextProps, nextState) {
    return !nextState.generatingBracket
  }

  render () {
    const { pool, viewer } = this.props
    const { current_user } = viewer
    const brackets = this.brackets()

    return <div className='user-bracket-list'>
      <div className='small-screen'>
        {brackets.map(bracket => <SmallBracket key={bracket.id} bracket={bracket} />)}
      </div>
      <div className='large-screen'>
        <table className='table-minimal'>
          <TableHeader bracketCount={brackets.length} />
          <tbody>
            {brackets.map(bracket => <BracketRow key={bracket.id} bracket={bracket} />)}
          </tbody>
        </table>
      </div>
      <div className='actions'>
        <PaymentButton pool={pool} unpaidBrackets={this.unpaidBrackets()} emailAddress={current_user.email} />
        <NewBracketButton pool={pool} bracketCount={brackets.length} clickHandler={this.trackNewBracketClick} />
      </div>
    </div>
  }
}

export default Relay.createContainer(UserBracketList, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        model_id
        started
        entry_fee
        brackets(first: 1000) {
          edges {
            node {
              id
              model_id
              name
              tie_breaker
              status
              final_four {
                id
                name
              }
            }
          }
        }
        ${NewBracketButton.getFragment('pool')}
        ${PaymentButton.getFragment('pool')}
      }
    `,
    viewer: () => Relay.QL`
      fragment on Viewer {
        current_user {
          email
        }
      }
    `
  }
})

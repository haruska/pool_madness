import React, { Component, PropTypes } from 'react'
import Relay from 'react-relay'
import CreateBracketMutation from 'mutations/create_bracket'

class NewBracketButton extends Component {
  static contextTypes = {
    router: PropTypes.object.isRequired
  }

  handleCreateSuccess = (transaction) => {
    const bracketId = transaction.create_bracket.bracket_edge.node.model_id
    window.location = `/brackets/${bracketId}/edit`
  }

  handleCreate = () => {
    const { pool, relay } = this.props

    const mutation = new CreateBracketMutation({
      pool: pool
    })

    relay.commitUpdate(mutation, {onSuccess: this.handleCreateSuccess})
  }

  render() {
    const { bracketCount } = this.props
    let button

    if (bracketCount > 0) {
      return <button className="minor" onClick={this.handleCreate}>Another Bracket Entry</button>
    } else {
      return <button onClick={this.handleCreate}>New Bracket Entry</button>
    }
  }
}

export default Relay.createContainer(NewBracketButton, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        ${CreateBracketMutation.getFragment('pool')}
      }
    `
  }
})
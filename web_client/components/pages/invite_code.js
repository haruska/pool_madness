import React, { Component } from 'react'
import Relay from 'react-relay'
import AcceptInvitationMutation from 'mutations/accept_invitation'

export default class InviteCode extends Component {
  static contextTypes = {
    setPageTitle: React.PropTypes.func.isRequired,
    router: React.PropTypes.object.isRequired
  }

  state = {value: '', error: ''}

  componentWillMount() {
    this.context.setPageTitle("Join Pool")
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  handleChange = (event) => {
    this.setState({value: event.target.value})
  }

  handleJoinPool = () => {
    let mutation = new AcceptInvitationMutation({invite_code: this.state.value})
    var onSuccess = () => {
      this.context.router.push(`/pools`)
    }

    var onFailure = (transaction) => {
      var error = transaction.getError() || new Error('Mutation failed.');
      this.setState({error: error})
    }

    Relay.Store.commitUpdate(mutation, {onFailure, onSuccess})
  }

  render() {
    return <div className="invite-code-page">
      <div className='invite-code-page-wrapper'>
        <h3>Invite code</h3>
        <input id="invite_code" type="text" value={this.state.value} onChange={this.handleChange} placeholder="Enter Invite Code" />
        <button onClick={this.handleJoinPool}>Join Pool</button>
      </div>
    </div>
  }
}

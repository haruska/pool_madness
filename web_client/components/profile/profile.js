import React, { Component } from 'react'
import Relay from 'react-relay'

class Profile extends Component {
  static contextTypes = {
    setPageTitle: React.PropTypes.func.isRequired
  }

  componentWillMount() {
    this.context.setPageTitle("Profile")
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  render() {
    const { current_user } = this.props

    return <div className="profile">
      <div className="name">{current_user.name}</div>
      <div className="email">{current_user.email}</div>
      <div className="actions">
        <a href="/user/edit" className="button">Edit Profile</a>
        <a href="/auth/edit" className="button minor">Change Password</a>
      </div>
    </div>
  }
}

export default Relay.createContainer(Profile, {
  fragments: {
    current_user: () => Relay.QL`
      fragment on CurrentUser {
        name
        email
      }
    `
  }
})
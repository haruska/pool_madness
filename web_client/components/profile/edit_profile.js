import React, { Component } from 'react'
import Relay from 'react-relay'
import { Link } from 'react-router'

class EditProfile extends Component {
  static contextTypes = {
    setPageTitle: React.PropTypes.func.isRequired
  }

  componentWillMount() {
    this.context.setPageTitle("Edit Profile")
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  render() {
    const { current_user } = this.props

    return <div className="edit-profile">
      <form method="post" action="/user">
        <input type="hidden" name="_method" value="patch" />
        <div className="form-inputs">
          <label htmlFor="user_name">Full Name</label>
          <input required="required" type="text" defaultValue={current_user.name} name="user[name]" id="user_name" />
          <label htmlFor="user_email">Email Address</label>
          <input required="required" type="text" defaultValue={current_user.email} name="user[email]" id="user_email" />
        </div>
        <div className="form-actions">
          <input type="submit" name="commit" defaultValue="Update" />
        </div>
      </form>
      <div className="other-actions">
        <Link to="/user" className="button minor">Cancel</Link>
      </div>
    </div>
  }
}

export default Relay.createContainer(EditProfile, {
  fragments: {
    current_user: () => Relay.QL`
      fragment on CurrentUser {
        name
        email
      }
    `
  }
})
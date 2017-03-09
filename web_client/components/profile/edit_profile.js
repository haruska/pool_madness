import React, { Component, PropTypes } from 'react'
import Relay from 'react-relay'
import { Link } from 'react-router'
import ErrorFlash from 'components/forms/error_flash'
import Label from 'components/forms/label'
import UpdateProfileMutation from 'mutations/update_profile'

class EditProfile extends Component {
  static contextTypes = {
    setPageTitle: PropTypes.func.isRequired,
    router: PropTypes.object.isRequired
  }

  state = {
    name: this.props.viewer.current_user.name,
    email: this.props.viewer.current_user.email,
    errors: null
  }

  componentWillMount() {
    this.context.setPageTitle("Edit Profile")
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  handleNameChange = (event) => {
    this.setState({name: event.target.value})
  }

  handleEmailChange = (event) => {
    this.setState({email: event.target.value})
  }

  handleUpdateSuccess = (transaction) => {
    let { errors } = transaction.update_profile
    if (errors) {
      this.setState({ errors })
    } else {
      this.context.router.push(`/user`)
    }
  }

  handleUpdateFailure = (error) => {
    console.log(error.getError().toString()) // eslint-disable-line
  }

  handleUpdate = (e) => {
    e.preventDefault()
    const {viewer, relay} = this.props
    const {name, email} = this.state

    const mutation = new UpdateProfileMutation({ viewer, name, email })

    relay.commitUpdate(mutation, {
      onSuccess: this.handleUpdateSuccess,
      onFailure: this.handleUpdateFailure
    })
  }

  render() {
    const { name, email, errors } = this.state

    return <div className="edit-profile">
      <form className="edit-profile-form" onSubmit={this.handleUpdate}>
        <div className="form-inputs">
          <ErrorFlash errors={errors} />
          <Label attr='name' text='Full Name' errors={errors} />
          <input name='name' type="text" value={name} onChange={this.handleNameChange} />
          <Label attr='email' text='Email Address' errors={errors} />
          <input required name='email' type="email" value={email} onChange={this.handleEmailChange} />
        </div>
        <div className="form-actions">
          <input type="submit" name="commit" defaultValue="Update" />
        </div>
        <div className="other-actions">
          <Link to="/user" className="button minor">Cancel</Link>
        </div>
      </form>
    </div>
  }
}

export default Relay.createContainer(EditProfile, {
  fragments: {
    viewer: () => Relay.QL`
      fragment on Viewer {
        current_user {
          name
          email
        }
        ${UpdateProfileMutation.getFragment('viewer')}
      }
    `
  }
})
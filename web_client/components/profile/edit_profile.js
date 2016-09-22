import React, { Component, PropTypes } from 'react'
import Relay from 'react-relay'
import { Link } from 'react-router'
import Label from 'components/forms/label'
import UpdateProfileMutation from 'mutations/update_profile'

class EditProfile extends Component {
  static contextTypes = {
    setPageTitle: PropTypes.func.isRequired,
    router: PropTypes.object.isRequired
  }

  state = {
    name: this.props.current_user.name,
    email: this.props.current_user.email,
    errors: {
      name: null,
      email: null
    }
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

  handleUpdateSuccess = () => {
    this.context.router.push('/user')
  }

  handleUpdateFailure = (mutationTransaction) => {
    const errors = JSON.parse(mutationTransaction.getError().source.errors[0].message)
    this.setState({errors: errors})
  }

  handleUpdate = () => {
    const {current_user, relay} = this.props
    const {name, email} = this.state

    const mutation = new UpdateProfileMutation({
      current_user: current_user,
      name: name,
      email: email
    })

    relay.commitUpdate(mutation, {
      onSuccess: this.handleUpdateSuccess,
      onFailure: this.handleUpdateFailure
    })
  }

  render() {
    const { name, email, errors } = this.state

    return <div className="edit-profile">
      <div className="form-inputs">
        <Label attrName='name' text='Full Name' errors={errors.name} />
        <input required="required" name='name' type="text" value={name} onChange={this.handleNameChange} />
        <Label attrName='email' text='Email Address' errors={errors.email} />
        <input required="required" name='email' type="email" value={email} onChange={this.handleEmailChange} />
      </div>
      <div className="form-actions">
        <input type="submit" name="commit" defaultValue="Update" onClick={this.handleUpdate} />
      </div>
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
        ${UpdateProfileMutation.getFragment('current_user')}
      }
    `
  }
})
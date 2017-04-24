import React, { Component } from 'react'
import Relay from 'react-relay'
import { Link } from 'react-router'

class Profile extends Component {
  static contextTypes = {
    setPageTitle: React.PropTypes.func.isRequired
  }

  componentWillMount () {
    this.context.setPageTitle('Profile')
  }

  componentWillUnmount () {
    this.context.setPageTitle()
  }

  render () {
    const { current_user } = this.props.viewer

    return <div className='profile'>
      <div className='name'>{current_user.name}</div>
      <div className='email'>{current_user.email}</div>
      <div className='actions'>
        <Link to='/user/edit' className='button'>Edit Profile</Link>
        <a href='/auth/edit' className='button minor'>Change Password</a>
      </div>
    </div>
  }
}

export default Relay.createContainer(Profile, {
  fragments: {
    viewer: () => Relay.QL`
      fragment on Viewer {
        current_user {
          name
          email
        }
      }
    `
  }
})

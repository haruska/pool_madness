import React, { Component } from 'react'
import Relay from 'react-relay'

class AdminList extends Component {
  render () {
    const { pool } = this.props

    return <div className='pool-admin-list'>
      <h3>Administrators</h3>
      <ul>
        {pool.admins.map(a => <li key={a.id}>{a.name}</li>)}
      </ul>
    </div>
  }
}

export default Relay.createContainer(AdminList, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        admins {
          id
          name
        }
      }
    `
  }
})

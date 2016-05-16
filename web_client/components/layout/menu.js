import React from 'react'
import { Link } from 'react-router'
import classNames from 'classnames'

export default React.createClass({
  getInitialState() {
    return { isVisible: false }
  },

  handleToggleMenuClick() {
    this.setState({ isVisible: !this.state.isVisible })
  },

  signedInLinks(contentClass) {
    return (
      <div>
        <a className="js-menu-trigger sliding-panel-button" onClick={this.handleToggleMenuClick}>
          <i className="fa fa-bars" />
        </a>
        <nav className={contentClass}>
          <li><Link to="/pools" onClick={this.handleToggleMenuClick}>All Pools</Link></li>
          <li><a href="/archived_pools">Archived Pools</a></li>
          <li><a href="/pools/invite_code">Enter Invite Code</a></li>
          <li><a href="/user">Profile</a></li>
          <li><a href="/auth/sign_out" data-method="delete">Logout</a></li>
        </nav>
      </div>
    )
  },

  render() {
    let isVisible = this.state.isVisible
    let contentClass = classNames('js-menu', 'sliding-panel-content', {'is-visible': isVisible})
    let panelClass = classNames('js-menu-screen', 'sliding-panel-fade-screen', {'is-visible': isVisible})
    let links = this.signedInLinks(contentClass)

    return (
      <div className="menu">
        {links}
        <div className={panelClass} onClick={this.handleToggleMenuClick}></div>
      </div>
    )
  }
})
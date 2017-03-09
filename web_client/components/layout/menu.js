import React, { Component } from 'react'
import { Link } from 'react-router'
import classNames from 'classnames'

export default class Menu extends Component {
  state = { isVisible: false }

  handleToggleMenuClick = () => {
    this.setState({isVisible: !this.state.isVisible})
  }

  poolLinks = () => {
    const { pool, viewer } = this.props
    const { current_user } = viewer
    let links = []


    if(pool.started) {
      links.push(<Link to={`/pools/${pool.model_id}/brackets`} onClick={this.handleToggleMenuClick}>Brackets</Link>)

      if(pool.tournament.games_remaining > 0 && pool.tournament.games_remaining < 4) {
        links.push(<Link to={`/pools/${pool.model_id}/possibilities`} onClick={this.handleToggleMenuClick}>Possible Outcomes</Link>)
      }
      links.push(<Link to={`/pools/${pool.model_id}/games`} onClick={this.handleToggleMenuClick}>Game Results</Link>)
    } else {
      links.push(<Link to={`/pools/${pool.model_id}/my_brackets`} onClick={this.handleToggleMenuClick}>My Brackets</Link>)
      links.push(<Link to={`/pools/${pool.model_id}/payments`} onClick={this.handleToggleMenuClick}>Types of Payment</Link>)
    }

    links.push(<Link to={`/pools/${pool.model_id}/rules`} onClick={this.handleToggleMenuClick}>Rules and Scoring</Link>)

    if(current_user.admin || this.currentUserIsPoolAdmin()) {
      links.push(<a href={`/admin/pools/${pool.model_id}/brackets`}>Pool Admin</a>)
    }

    links.push(<Link to="/pools" onClick={this.handleToggleMenuClick}>Other Pools</Link>)

    return links
  }

  buildLinks = () => {
    const { pool } = this.props

    if(pool) {
      return this.poolLinks()
    } else {
      return [<Link key='all-pools-link' to="/pools" onClick={this.handleToggleMenuClick}>All Pools</Link>]
    }
  }

  signedInLinks = (contentClass) => {
    return (
      <div>
        <a className="js-menu-trigger sliding-panel-button" onClick={this.handleToggleMenuClick}>
          <i className="fa fa-bars" />
        </a>
        <nav className={contentClass}>
          <ul>
            {this.buildLinks().map((link, i) => <li key={`link-${i}`}>{link}</li>)}
          </ul>
          <ul>
            <li><Link to="/pools/invite_code" onClick={this.handleToggleMenuClick}>Enter Invite Code</Link></li>
            <li><Link to="/user" onClick={this.handleToggleMenuClick}>Profile</Link></li>
            <li><a href="/auth/sign_out">Logout</a></li>
          </ul>
        </nav>
      </div>
    )
  }

  currentUserIsPoolAdmin = () => {
    const { pool, viewer } = this.props
    const { current_user } = viewer
    const adminIds = pool.admins.map(admin => admin.model_id)

    return adminIds.includes(current_user.model_id)
  }

  render() {
    const isVisible = this.state.isVisible
    const contentClass = classNames('js-menu', 'sliding-panel-content', {'is-visible': isVisible})
    const panelClass = classNames('js-menu-screen', 'sliding-panel-fade-screen', {'is-visible': isVisible})
    const links = this.signedInLinks(contentClass)

    return (
      <div className="menu">
        {links}
        <div className={panelClass} onClick={this.handleToggleMenuClick} />
      </div>
    )
  }
}
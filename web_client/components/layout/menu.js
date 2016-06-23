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

  poolLinks() {
    let { pool, current_user } = this.props
    let links = []

    links.push(<Link to={`/pools/${pool.model_id}`} onClick={this.handleToggleMenuClick}>Brackets</Link>)

    if(pool.started) {
      if(pool.tournament.games_remaining > 0 && pool.tournament.games_remaining < 4) {
        links.push(<a href={`/pools/${pool.model_id}/possibilities`}>Possible Outcomes</a>)
      }
      links.push(<a href={`/pools/${pool.model_id}/games`}>Game Results</a>)
    } else {
      links.push(<a href={`/pools/${pool.model_id}/payments`}>Types of Payment</a>)
    }

    links.push(<a href={`/pools/${pool.model_id}/rules`}>Rules and Scoring</a>)

    if(current_user.admin) {
      links.push(<a href={`/admin/pools/${pool.model_id}/brackets`}>Pool Admin</a>)
    }

    links.push(<Link to="/pools" onClick={this.handleToggleMenuClick}>Other Pools</Link>)

    return links
  },

  buildLinks() {
    let pool = this.props.pool

    if(pool) {
      return this.poolLinks()
    } else {
      return [<Link key='all-pools-link' to="/pools" onClick={this.handleToggleMenuClick}>All Pools</Link>]
    }
  },

  signedInLinks(contentClass) {
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
            <li><a href="/pools/invite_code">Enter Invite Code</a></li>
            <li><a href="/user">Profile</a></li>
            <li><a href="/auth/sign_out">Logout</a></li>
          </ul>
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
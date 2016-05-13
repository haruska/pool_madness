import React from 'react'
import { Link } from 'react-router'

function Title(props) {
  return (
    <div className='title-wrapper'>
      <div className='title'>{props.title || "Pool Madness"}</div>
    </div>
  )
}

function Menu() {
  return (
    <div className='js-menu-trigger sliding-panel-button menu'>
      <i className='fa fa-bars'/>
    </div>
  )
}

function Nav() {
  return (
    <nav className='js-menu sliding-panel-content'>
      <ul>
        <li><Link to="/pools">All Pools</Link></li>
        <li><a href="/archived_pools">Archived Pools</a></li>
        <li><a href="/pools/invite_code">Enter Invite Code</a></li>
        <li><a href="/user">Profile</a></li>
        <li><a href="/auth/sign_out" data-method="delete">Logout</a></li>
      </ul>
    </nav>
  )
}

export default function Header(props) {
  return (
    <header>
      <Title title={props.title}/>
      <Menu />
      <Nav />
      <div className="js-menu-screen sliding-panel-fade-screen"></div>
    </header>
  )
}

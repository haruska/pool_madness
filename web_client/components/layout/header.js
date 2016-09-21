import React, { Component } from 'react'
import Menu from './menu'

class Title extends Component {
  render() {
    return (
      <div className='title-wrapper'>
        <div className='title'>{this.props.title || "Pool Madness"}</div>
      </div>
    )
  }
}
export default class Header extends Component {
  render() {
    const {title, ...other} = this.props
    return (
      <header>
        <Title title={title}/>
        <Menu {...other}/>
      </header>
    )
  }
}

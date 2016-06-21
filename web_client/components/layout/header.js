import React from 'react'
import Menu from './menu'

function Title(props) {
  return (
    <div className='title-wrapper'>
      <div className='title'>{props.title || "Pool Madness"}</div>
    </div>
  )
}

export default function Header(props) {
  return (
    <header>
      <Title title={props.title}/>
      <Menu pool={props.pool}/>
    </header>
  )
}

import React from 'react'

export default function Layout(props) {
  return <div className='layout'>
    <div id='main-container'>
      <div id='container'>
        {props.children}
      </div>
    </div>
  </div>
}

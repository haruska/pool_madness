import React from 'react'
import { Route, IndexRoute } from 'react-router'
import { RelayRouter } from 'react-router-relay'
import { browserHistory } from 'react-router'

function NoMatch() {
  return <div>The page you are looking for could not be found :(</div>
}

export default function() {
  return (
    <RelayRouter history={browserHistory}>
      <Route path='*' component={NoMatch}/>
    </RelayRouter>
  )
}
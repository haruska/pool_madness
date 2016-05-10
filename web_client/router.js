import React from 'react'
import { Router, Route, IndexRoute, Link, browserHistory, applyRouterMiddleware } from 'react-router'
import { Relay } from 'react-relay'
import { useRelay } from 'react-router-relay'

import Layout from './components/layout/layout'
import App from './components/app'

function NoMatch() {
  return <Layout>The page you are looking for could not be found :(</Layout>
}

export default function PoolMadnessRouter() {
  return (
    <Router history={browserHistory}>
      <Route path="/" component={App}>
        <Route path='*' component={NoMatch}/>
      </Route>
    </Router>
  )
}
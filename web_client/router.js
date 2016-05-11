import React from 'react'
import { Router, Route, browserHistory } from 'react-router'

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
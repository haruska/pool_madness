import React from 'react'
import Relay from 'react-relay'
import { Router, Route, browserHistory, applyRouterMiddleware } from 'react-router'
import useRelay from 'react-router-relay'

import Layout from './components/layout/layout'
import App from './components/app'
import PoolList from './components/pools/pool_list'

function NoMatch() {
  return <Layout>The page you are looking for could not be found :(</Layout>
}

const ListsQueries = {
  lists: () => Relay.QL`query { lists }`
}

export default function() {
  return (
    <Router history={browserHistory} render={applyRouterMiddleware(useRelay)} environment={Relay.Store}>
      <Route path="/" component={App}>
        <Route component={Layout}>
          <Route path="pools" component={PoolList} queries={ListsQueries}/>
        </Route>
        <Route path='*' component={NoMatch}/>
      </Route>
    </Router>
  )
}


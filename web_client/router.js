import React from 'react'
import Relay from 'react-relay'
import { Router, Route, IndexRoute, browserHistory, applyRouterMiddleware } from 'react-router'
import useRelay from 'react-router-relay'

import Layout from './components/layout/layout'
import App from './components/app'
import PoolList from './components/pools/pool_list'
import Pool from './components/pools/pool'
import PoolLayout from './components/layout/pool'
import BracketList from './components/brackets/bracket_list'
import UserBracketList from './components/brackets/user_bracket_list'

function NoMatch() {
  return <Layout>The page you are looking for could not be found :(</Layout>
}

const ListsQueries = {
  lists: () => Relay.QL`query { lists }`
}

const PoolQueries = {
  pool: () => Relay.QL`
    query {
      pool(model_id: $poolId)
    }
  `
}

export default function() {
  return (
    <Router history={browserHistory} render={applyRouterMiddleware(useRelay)} environment={Relay.Store}>
      <Route path="/" component={App}>
        <Route component={Layout}>
          <Route path="pools" component={PoolList} queries={ListsQueries}/>
        </Route>
        <Route path="pools/:poolId" component={PoolLayout} queries={PoolQueries}>
          <IndexRoute component={Pool} queries={PoolQueries} />
          <Route path="brackets" component={BracketList} queries={PoolQueries}/>
          <Route path="my_brackets" component={UserBracketList} queries={PoolQueries}/>
        </Route>
        <Route path='*' component={NoMatch}/>
      </Route>
    </Router>
  )
}


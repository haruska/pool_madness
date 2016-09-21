import Relay from 'react-relay'
import ReactDOM from 'react-dom'

import PoolMadnessRouter from 'router'

// use cookie-based auth until migration complete
Relay.injectNetworkLayer(new Relay.DefaultNetworkLayer('/graphql', { credentials: 'same-origin'}))

ReactDOM.render(PoolMadnessRouter(), document.getElementById('outer-container'))
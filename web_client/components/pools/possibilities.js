import React, { Component } from 'react'
import Relay from 'react-relay'
import {ordinalInWord} from 'utils/ordinals'

class WinningBrackets extends Component {
  render() {
    const { position, brackets } = this.props
    if (brackets) {
      return (
        <li>{ordinalInWord(position)}: {brackets.map(b => b.name).join(', ')}</li>
      )
    }
    else {
      return null
    }
  }
}
class Championship extends Component {
  render() {
    const { winning_team, losing_team } = this.props.championship
    return <h3>{winning_team.name} BEATS {losing_team.name}</h3>
  }
}

class Possibility extends Component {
  render() {
    const { championships, first_place, second_place, third_place } = this.props.possibility
    const winningBrackets = [first_place, second_place, third_place]
    return(
      <div className='possibility'>
        {championships.map((c, i) => <Championship key={`championship-${i}`} championship={c}/>)}
        <ul className='winning-brackets-list'>
          {winningBrackets.map((bList, i) => <WinningBrackets key={`winningBracket-${i}`} position={i+1} brackets={bList}/>)}
        </ul>
      </div>
    )
  }
}

class Possibilities extends Component {
  static contextTypes = {
    setPageTitle: React.PropTypes.func.isRequired
  }

  componentWillMount() {
    this.context.setPageTitle("Possible Winners")
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  render() {
    const { possibilities, name } = this.props.pool
    return (
      <div className='possibilities-page'>
        <h1>{name} Pool Possibilities</h1>
        {possibilities.map((possibility, i) => <Possibility key={`possibility-${i}`} possibility={possibility}/>)}
      </div>
    )
  }
}

export default Relay.createContainer(Possibilities, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        name
        possibilities {
          championships {
            winning_team {
              name
            }
            losing_team {
              name
            }
          }
          first_place {
            model_id
            name
          }
          second_place {
            model_id
            name
          }
          third_place {
            model_id
            name
          }  
        }
      }
    `
  }
})

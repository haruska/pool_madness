import React, { Component, PropTypes } from 'react'
import Relay from 'react-relay'

import { cloneDeep } from 'lodash'

import Dialog from 'components/dialog'
import PoolLayout from 'components/layout/pool'
import Tournament from 'components/bracket/tournament'
import DeleteBracketMutation from 'mutations/delete_bracket'

class Bracket extends Component {
  static contextTypes = {
    router: PropTypes.object.isRequired,
    setPageTitle: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)

    this.state = {
      bracket: cloneDeep(props.bracket),
      name: props.bracket.name,
      tie_breaker: props.bracket.tie_breaker || '0',
      errors: null,
      showsDeletionDialog: false
    }
  }

  componentWillMount() {
    this.context.setPageTitle("Editing Bracket")
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  title = () => {
    const { bracket } = this.props
    const { owner } = bracket

    if (bracket.name.startsWith(owner.name)) {
      return `${bracket.name} Bracket`
    }
    else {
      return `${bracket.name} (${owner.name}) Bracket`
    }
  }

  handleSlotClick = (slotId, choice) => {
    let bracket = cloneDeep(this.state.bracket)
    let gameDecisions = bracket.game_decisions.split('')
    let gameMask = bracket.game_mask.split('')

    gameDecisions[slotId] = choice - 1
    gameMask[slotId] = 1

    bracket.game_decisions = gameDecisions.join('')
    bracket.game_mask = gameMask.join('')

    this.setState({bracket: bracket})
  }

  handleNameChange = (event) => {
    this.setState({name: event.target.value})
  }

  handleTieBreakerChange = (event) => {
    this.setState({tie_breaker: event.target.value})
  }

  handleDone = (event) => {
    event.preventDefault()
    this.context.router.push(`/brackets/${this.props.bracket.model_id}`)
  }

  // deletion
  handleDelete = () => {
    this.setState({ showsDeletionDialog: true })
  }

  handleCancelDeletion = () => {
    this.setState({ showsDeletionDialog: false })
  }

  handleConfirmDeletion = () => {
    this.setState({ showsDeletionDialog: false })

    const { router } = this.context
    const { bracket, relay } = this.props

    const mutation = new DeleteBracketMutation({ bracket })

    relay.commitUpdate(mutation, {
      onSuccess () {
        router.push(`/pools/${bracket.pool.model_id}`)
      },
      onFailure (error) {
        console.error(`commit failed: ${error}`) // eslint-disable-line
      }
    })
  }

  shouldComponentUpdate(nextProps) {
    if (nextProps.bracket) {
      return true
    }
    return false
  }

  render() {
    const { bracket } = this.state
    const pool = bracket.pool
    const tournament = pool.tournament

    return <div className="bracket-edit">
      <Dialog
        className='deletion'
        isOpen={this.state.showsDeletionDialog}
        message='This will delete this bracket. Are you sure you want to proceed?'
        onConfirm={this.handleConfirmDeletion}
        onCancel={this.handleCancelDeletion}
      />
      <h2>{this.title()}</h2>
      <Tournament tournament={tournament} bracket={bracket} onSlotClick={this.handleSlotClick}/>
      <form className="edit-bracket-form" onSubmit={this.handleDone}>
        <label htmlFor="bracket_name">Bracket Name</label>
        <input id="bracket_name" type="text" name="bracket_name" value={this.state.name} onChange={this.handleNameChange} />
        <label htmlFor="tie_breaker">Tie Breaker</label>
        <input id="tie_breaker" name="tie_breaker" placeholder="Final Score of Championship Game Added Together (ex: 147)" type="text" value={this.state.tie_breaker} onChange={this.handleTieBreakerChange} />
        <input className="button" type="submit" name="commit" value="Done" />
        <div className="button danger" onClick={this.handleDelete}>Delete Bracket</div>
      </form>
    </div>
  }
}

export default Relay.createContainer(Bracket, {
  fragments: {
    bracket: () => Relay.QL`
      fragment on Bracket {
        model_id
        name
        tie_breaker
        game_decisions
        game_mask
        editable
        owner {
          name
        }  
        pool {
          model_id
          ${PoolLayout.getFragment('pool')}
          tournament {
            ${Tournament.getFragment('tournament')}
          }
        }
        ${DeleteBracketMutation.getFragment('bracket')}
      }
    `
  }
})
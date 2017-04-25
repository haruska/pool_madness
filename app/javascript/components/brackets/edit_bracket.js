import React, { Component, PropTypes } from 'react'
import Relay from 'react-relay'

import { cloneDeep } from 'lodash'

import Dialog from 'components/dialog'
import ErrorFlash from 'components/forms/error_flash'
import Label from 'components/forms/label'
import PoolLayout from 'components/layout/pool'
import Tournament from 'components/bracket/tournament'
import UpdateBracketMutation from 'mutations/update_bracket'
import DeleteBracketMutation from 'mutations/delete_bracket'

class Bracket extends Component {
  static contextTypes = {
    router: PropTypes.object.isRequired,
    setPageTitle: PropTypes.func.isRequired
  }

  constructor (props) {
    super(props)

    this.state = {
      bracket: cloneDeep(props.bracket),
      name: props.bracket.name,
      tie_breaker: props.bracket.tie_breaker || '0',
      errors: null,
      showsDeletionDialog: false
    }
  }

  componentWillMount () {
    this.context.setPageTitle('Editing Bracket')
  }

  componentWillUnmount () {
    this.context.setPageTitle()
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
    const intValue = event.target.value ? parseInt(event.target.value) : ''
    this.setState({tie_breaker: intValue})
  }

  handleUpdateSuccess = (transaction) => {
    let { errors } = transaction.update_bracket
    if (errors) {
      this.setState({ errors })
    } else {
      this.context.router.push(`/brackets/${this.props.bracket.model_id}`)
    }
  }

  handleUpdateFailure = (error) => {
    console.log(error.getError().toString()) // eslint-disable-line
  }

  handleDone = (event) => {
    event.preventDefault()

    const {bracket, relay} = this.props
    const {name, tie_breaker} = this.state
    const {game_decisions, game_mask} = this.state.bracket

    const mutation = new UpdateBracketMutation({
      bracket,
      name,
      tie_breaker,
      game_decisions,
      game_mask
    })

    relay.commitUpdate(mutation, {
      onSuccess: this.handleUpdateSuccess,
      onFailure: this.handleUpdateFailure
    })
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

  shouldComponentUpdate (nextProps) {
    if (nextProps.bracket) {
      return true
    }
    return false
  }

  render () {
    const { bracket, errors } = this.state
    const pool = bracket.pool
    const tournament = pool.tournament

    return <div className='bracket-edit'>
      <Dialog
        className='deletion'
        isOpen={this.state.showsDeletionDialog}
        message='This will delete this bracket. Are you sure you want to proceed?'
        onConfirm={this.handleConfirmDeletion}
        onCancel={this.handleCancelDeletion}
      />
      <h2 className='edit-title'>Editing Bracket</h2>
      <Tournament tournament={tournament} bracket={bracket} onSlotClick={this.handleSlotClick} />
      <form className='edit-bracket-form' onSubmit={this.handleDone}>
        <ErrorFlash errors={errors} />
        <Label attr='name' text='Bracket Name' errors={errors} />
        <input id='name' type='text' name='name' required value={this.state.name} onChange={this.handleNameChange} />

        <Label attr='tie_breaker' text='Tie Breaker' errors={errors} />
        <input id='tie_breaker' name='tie_breaker' required placeholder='Final Score of Championship Game Added Together (ex: 147)' type='number' value={this.state.tie_breaker} onChange={this.handleTieBreakerChange} />

        <input className='button' type='submit' name='commit' value='Done' />
        <div className='button danger' onClick={this.handleDelete}>Delete Bracket</div>
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
        ${UpdateBracketMutation.getFragment('bracket')}
        ${DeleteBracketMutation.getFragment('bracket')}
      }
    `
  }
})

import React, { Component, PropTypes } from 'react'
import Relay from 'react-relay'

import Dialog from 'components/dialog'
import ErrorFlash from 'components/forms/error_flash'
import Label from 'components/forms/label'
import PoolLayout from 'components/layout/pool'
import Tournament from 'components/bracket/tournament'
import CreateBracketMutation from 'mutations/create_bracket'

class NewBracket extends Component {
  static contextTypes = {
    router: PropTypes.object.isRequired,
    setPageTitle: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)

    this.state = {
      name: props.viewer.current_user.name,
      decisions: props.pool.tournament.game_decisions,
      mask: props.pool.tournament.game_mask,
      tie_breaker: '',
      errors: null,
      showsDiscardDialog: false
    }
  }

  componentWillMount() {
    this.context.setPageTitle("New Bracket")
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  handleSlotClick = (slotId, choice) => {
    let decisions = this.state.decisions.split('')
    let mask = this.state.mask.split('')

    decisions[slotId] = choice - 1
    mask[slotId] = 1

    this.setState({
      decisions: decisions.join(''),
      mask: mask.join('')
    })
  }

  handleNameChange = (event) => {
    this.setState({name: event.target.value})
  }

  handleTieBreakerChange = (event) => {
    const intValue = event.target.value ? parseInt(event.target.value) : ""
    this.setState({tie_breaker: intValue})
  }

  handleSuccess = (transaction) => {
    let { errors } = transaction.create_bracket
    if (errors) {
      this.setState({ errors })
    } else {
      this.context.router.push(`/pools/${this.props.pool.model_id}`)
    }
  }

  handleFailure = (error) => {
    console.log(error.getError().toString()) // eslint-disable-line
  }

  handleDone = (event) => {
    event.preventDefault()

    const {pool, relay} = this.props
    const {name, tie_breaker, decisions, mask} = this.state

    const mutation = new CreateBracketMutation({
      pool,
      name,
      tie_breaker,
      game_decisions: decisions,
      game_mask: mask
    })

    relay.commitUpdate(mutation, {
      onSuccess: this.handleSuccess,
      onFailure: this.handleFailure
    })
  }

  // cancel
  handleDiscard = () => {
    this.setState({ showsDiscardDialog: true })
  }

  handleCancelDiscard = () => {
    this.setState({ showsDiscardDialog: false })
  }

  handleConfirmDiscard = () => {
    this.setState({ showsDiscardDialog: false })
    this.context.router.push(`/pools/${this.props.pool.model_id}`)
  }

  render() {
    const { pool } = this.props
    const { name, decisions, mask, tie_breaker, errors } = this.state
    const tournament = pool.tournament

    const bracket = {
      name,
      tie_breaker,
      game_decisions: decisions,
      game_mask: mask
    }

    return <div className="bracket-edit">
      <Dialog
        className='deletion'
        isOpen={this.state.showsDiscardDialog}
        message='You will lose your changes. Are you sure you want to proceed?'
        onConfirm={this.handleConfirmDiscard}
        onCancel={this.handleCancelDiscard}
      />
      <h2>New Bracket Entry</h2>
      <Tournament tournament={tournament} bracket={bracket} onSlotClick={this.handleSlotClick}/>
      <form className="edit-bracket-form" onSubmit={this.handleDone}>
        <ErrorFlash errors={errors} />
        <Label attr="name" text="Bracket Name" errors={errors} />
        <input id="name" type="text" name="name" required value={this.state.name} onChange={this.handleNameChange} />

        <Label attr="tie_breaker" text="Tie Breaker" errors={errors} />
        <input id="tie_breaker" name="tie_breaker" required placeholder="Final Score of Championship Game Added Together (ex: 147)" type="number" value={this.state.tie_breaker} onChange={this.handleTieBreakerChange} />

        <input className="button" type="submit" name="commit" value="Done" />
        <div className="button danger" onClick={this.handleDiscard}>Discard Bracket</div>
      </form>
    </div>
  }
}

export default Relay.createContainer(NewBracket, {
  fragments: {
    viewer: () => Relay.QL`
      fragment on Viewer {
        current_user {
          name
        }
      }
    `,
    pool: () => Relay.QL`
      fragment on Pool {
        model_id
        tournament {
          game_decisions
          game_mask
          ${Tournament.getFragment('tournament')}
        }
        ${PoolLayout.getFragment('pool')}
        ${CreateBracketMutation.getFragment('pool')}
      }
    `
  }
})
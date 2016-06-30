import React from 'react'
import Relay from 'react-relay'
import { ReactScriptLoaderMixin } from 'react-script-loader'
import CreateChargeMutation from '../../mutations/create_charge'
import pluralize from 'pluralize'

let PaymentButton = React.createClass({
  mixins: [ ReactScriptLoaderMixin ],

  getInitialState() {
    return {
      stripeCheckout: null
    }
  },

  getScriptURL() {
    return 'https://checkout.stripe.com/checkout.js'
  },

  onScriptLoaded() {
    let handler = StripeCheckout.configure({
      key: 'pk_test_fQOiDeixudLD4YxlJa0jXxYh',
      image: '/favicon.png',
      locale: 'auto',
      token: this.handleStripeToken
    })

    this.setState({stripeCheckout: handler})
  },

  onScriptError() {
    // if script does not load?
  },

  handleStripeToken(token) {
    Relay.Store.commitUpdate(
      new CreateChargeMutation({pool: this.props.pool, token: token.id})
    )
  },

  handlePaymentClick(e) {
    var {pool, unpaidBrackets, emailAddress} = this.props
    let entryFee = pool.entry_fee

    let bracketCount = unpaidBrackets.length
    let amount = bracketCount * entryFee
    let description = `${bracketCount} ${pluralize('bracket', bracketCount)}`

    this.state.stripeCheckout.open({
      name: 'Pool Madness',
      description: description,
      amount: amount,
      email: emailAddress,
      allowRememberMe: false
    })

    e.preventDefault()
  },

  render() {
    var { unpaidBrackets } = this.props

    if(unpaidBrackets && unpaidBrackets.length > 0 && this.state.stripeCheckout) {
      return <button onClick={this.handlePaymentClick}>Pay Now</button>
    }
    else {
      return false
    }
  }
})

export default Relay.createContainer(PaymentButton, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        entry_fee
        ${CreateChargeMutation.getFragment('pool')}
      }
    `
  }
})
import React, { Component } from 'react'
import Relay from 'react-relay'
import CreateChargeMutation from 'mutations/create_charge'
import pluralize from 'pluralize'
import LoadStripe from 'components/payments/load_stripe'

class PaymentButton extends Component {
  state = { stripeCheckout: null }

  onScriptLoaded = () => {
    let handler = StripeCheckout.configure({
      key: 'pk_live_zkts04HcHkzLExcpUgG41Huk',
      image: '/favicon.png',
      locale: 'auto',
      token: this.handleStripeToken
    })

    this.setState({stripeCheckout: handler})
  }

  handleStripeToken = (token) => {
    Relay.Store.commitUpdate(
      new CreateChargeMutation({pool: this.props.pool, token: token.id})
    )
  }

  handlePaymentClick = (e) => {
    const {pool, unpaidBrackets, emailAddress} = this.props
    const entryFee = pool.entry_fee
    const bracketCount = unpaidBrackets.length
    const amount = bracketCount * entryFee
    const description = `${bracketCount} ${pluralize('bracket', bracketCount)}`

    this.state.stripeCheckout.open({
      name: 'Pool Madness',
      description: description,
      amount: amount,
      email: emailAddress,
      allowRememberMe: false
    })

    e.preventDefault()
  }

  renderButton = () => {
    if(this.state.stripeCheckout) {
      return <button onClick={this.handlePaymentClick}>Pay Now</button>
    }
    else {
      return false
    }
  }

  render() {
    const { unpaidBrackets } = this.props
    if(unpaidBrackets && unpaidBrackets.length > 0) {
      return <div className='payment-button'>
        <LoadStripe onScriptLoaded={this.onScriptLoaded} />
        {this.renderButton()}
      </div>
    }
    else {
      return false
    }
  }
}

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
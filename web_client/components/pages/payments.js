import React, { Component } from 'react'
import { Link } from 'react-router'
import Relay from 'react-relay'

class Payments extends Component {
  static contextTypes = {
    setPageTitle: React.PropTypes.func.isRequired
  }

  componentWillMount() {
    this.context.setPageTitle("Types of Payment")
  }

  componentWillUnmount() {
    this.context.setPageTitle()
  }

  render() {
    let { pool } = this.props

    return <div className="pool-payment-types">
      <section id="cash">
        <h3>Cash</h3>
        <p>
          Cash in person is by far the easiest option. Note that because of lack of payment by some entries last year,
          <strong>&nbsp;you must pay an admin in person before tip off or your entry will be voided.</strong>
        </p>
      </section>
      <section id="credit-card">
        <h3>Credit Card</h3>
        <p>
          We accept all major credit cards. Just select "Pay Now" on <Link to={`/pools/${pool.model_id}/my_brackets`}>your brackets</Link> page.
        </p>
      </section>
      <section id="paypal">
        <h3>Paypal</h3>
        <p>
          If you wish to pay by PayPal, just email an administrator and they'll send you a payment request to complete
          on PayPal.
        </p>
      </section>
    </div>
  }
}

export default Relay.createContainer(Payments, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        model_id
      }
    `
  }
})
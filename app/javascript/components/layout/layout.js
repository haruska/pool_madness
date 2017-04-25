import React, { Component } from 'react'
import Header from './header'

export default class Layout extends Component {
  static childContextTypes = {
    setPageTitle: React.PropTypes.func.isRequired
  }

  state = { title: 'Pool Madness' }

  getChildContext () {
    return {
      setPageTitle: this.setPageTitle
    }
  }

  setPageTitle = (title) => {
    const newTitle = title || 'Pool Madness'
    this.setState({title: newTitle})
  }

  render () {
    return (
      <div className='layout'>
        <Header title={this.state.title} {...this.props} />
        <section className='container' id='content'>
          {this.props.children}
        </section>
        <footer />
      </div>
    )
  }
}

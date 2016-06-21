import React from 'react'
import Header from './header'

export default React.createClass({
  childContextTypes: {
    setPageTitle: React.PropTypes.func.isRequired,
    setCurrentPool: React.PropTypes.func.isRequired
  },

  getChildContext() {
    return {
      setPageTitle: this.setPageTitle,
      setCurrentPool: this.setCurrentPool
    }
  },

  setPageTitle(title) {
    let newTitle = title || "Pool Madness"
    this.setState({title: newTitle})
  },

  setCurrentPool(pool) {
    this.setState({pool: pool})
  },

  getInitialState() {
    return {
      title: "Pool Madness",
      pool: null
    }
  },

  render() {
    return (
      <div className='layout'>
        <Header title={this.state.title} pool={this.state.pool}/>
        <section className='container' id='content'>
          {this.props.children}
        </section>
        <footer/>
      </div>
    )
  }
})
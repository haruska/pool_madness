import React from 'react'
import Header from './header'

export default React.createClass({
  childContextTypes: {
    setPageTitle: React.PropTypes.func.isRequired
  },

  getChildContext() {
    return {
      setPageTitle: this.setPageTitle
    }
  },

  setPageTitle(title) {
    let newTitle = title || "Pool Madness"
    this.setState({title: newTitle})
  },

   getInitialState() {
    return {
      title: "Pool Madness"
    }
  },

  render() {
    return (
      <div className='layout'>
        <Header title={this.state.title} pool={this.props.pool}/>
        <section className='container' id='content'>
          {this.props.children}
        </section>
        <footer/>
      </div>
    )
  }
})
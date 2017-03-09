import React, { Component, PropTypes } from 'react'

export default class ErrorFlash extends Component {
  static propTypes = {
    errors: PropTypes.any,
    message: PropTypes.string
  }

  static defaultProps = {
    message: 'There was an issue. See below.'
  }

  state = {
    visible: false
  }

  // properties
  timer = null

  // timer
  showFlash () {
    // clear any existing timer
    clearTimeout(this.timer)

    // hide after 5 seconds
    this.setState({ visible: true })

    this.timer = setTimeout(() => {
      this.setState({ visible: false })
      this.timer = null
    }, 5000)
  }

  // lifecycle
  componentDidMount () {
    if (this.props.errors) {
      this.showFlash()
    }
  }

  componentWillReceiveProps (nextProps) {
    // reset the timer if errors are different
    if (nextProps.errors !== this.props.errors) {
      this.showFlash()
    }
  }

  componentWillUnmount () {
    clearTimeout(this.timer)
  }

  render () {
    const { message } = this.props

    if (this.state.visible) {
      return <div className='flash-error'>{message}</div>
    }

    return null
  }
}
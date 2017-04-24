import React, { Component, PropTypes } from 'react'

export default class ErrorFlash extends Component {
  static propTypes = {
    errors: PropTypes.any,
    message: PropTypes.string,
    objectType: PropTypes.string
  }

  static defaultProps = {
    message: 'There was an issue. See below.',
    objectType: 'Below'
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

  message = () => {
    const { errors, message } = this.props
    if (errors) {
      const baseError = errors.find(error => error.key === 'base')
      if (baseError) {
        return `${this.props.objectType} ${baseError.messages[0]}`
      }
    }
    return message
  }

  render () {
    if (this.state.visible) {
      return <div className='flash-error'>{this.message()}</div>
    }

    return null
  }
}

import React, { Component, PropTypes } from 'react'

export default class Dialog extends Component {
  static propTypes = {
    isOpen: PropTypes.bool.isRequired,
    message: PropTypes.string,
    onConfirm: PropTypes.func,
    onCancel: PropTypes.func
  }

  render () {
    if (!this.props.isOpen) {
      return null
    }

    return (
      <div className='dialog-container'>
        <div className='dialog'>
          <div className='dialog-title'>
            <p>{this.props.message}</p>
          </div>

          <div className='dialog-actions'>
            <button className='dialog-cancel' onClick={this.props.onCancel}>Cancel</button>
            <button className='dialog-confirm delete' onClick={this.props.onConfirm}>Confirm</button>
          </div>
        </div>
      </div>
    )
  }
}

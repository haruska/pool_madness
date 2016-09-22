import React, { Component } from 'react'

export default class Label extends Component {
  render() {
    const {attrName, text, errors} = this.props

    if (errors && errors.length > 0) {
      return <label htmlFor={attrName} className="error">{text} {errors[0]}</label>
    }
    return <label htmlFor={attrName}>{text}</label>
  }
}
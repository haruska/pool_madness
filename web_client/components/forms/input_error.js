import React from 'react'

function InputError (props) {
  let {attr, errors} = props
  if (errors) {
    let attrError = errors.find(e => e.key === attr)
    if (attrError) {
      return <span className='input-error'>&nbsp;{attrError.messages[0]}</span>
    }
  }

  return null
}

export default InputError
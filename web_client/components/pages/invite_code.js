import React from 'react'

export default React.createClass({
  contextTypes: {
    setPageTitle: React.PropTypes.func.isRequired
  },

  componentWillMount() {
    this.context.setPageTitle("Join Pool")
  },

  componentWillUnmount() {
    this.context.setPageTitle()
  },

  render() {
    return <div className="invite-code-page">
      <form method="post" action="/pools/join">
        <label htmlFor="invite_code">Invite code</label>
        <input type="text" name="invite_code" id="invite_code" />
        <input type="submit" name="commit" value="Join Pool" />
      </form>
    </div>
  }
})

export default class GameNode {
  constructor(tree, slot, decision) {
    this.tree = tree
    this.slot = slot
    this.decision = decision
  }

  firstTeamStartingSlot = () => {
    if (this.isRoundOne()) {
      return this.leftPosition()
    }
    else {
      const leftGame = this.leftGame()
      return leftGame ? leftGame.winningTeamStartingSlot() : null
    }
  }

  secondTeamStartingSlot = () => {
    if (this.isRoundOne()) {
      return this.rightPosition()
    }
    else {
      const rightGame = this.rightGame()
      return rightGame ? rightGame.winningTeamStartingSlot() : null
    }
  }

  winningTeamStartingSlot = () => {
    if (this.decision == 0) {
      if (this.leftGame()) {
        return this.leftGame().winningTeamStartingSlot()
      }
      else {
        return this.leftPosition()
      }
    }
    else if (this.decision == 1) {
      if (this.rightGame()) {
        return this.rightGame().winningTeamStartingSlot()
      }
      else {
        return this.rightPosition()
      }
    }
    else {
      return null
    }
  }

  leftPosition = () => {
    return this.slot * 2
  }

  rightPosition = () => {
    return this.leftPosition() + 1
  }

  parentPosition = () => {
    return parseInt((this.slot % 2 == 0 ? this.slot + 1 : this.slot) / 2)
  }

  leftGame = () => {
    return this.tree.gameNodes[this.leftPosition()]
  }

  rightGame = () => {
    return this.tree.gameNodes[this.rightPosition()]
  }

  parentGame = () => {
    return this.tree.gameNodes[this.parentPosition()]
  }

  isRoundOne = () => {
    return !this.leftGame() && !this.rightGame()
  }
}
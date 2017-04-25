export default class Team {
  constructor (tournament, tree, startingSlot) {
    this.tournament = tournament
    this.tree = tree
    this.startingSlot = startingSlot
    this.graphTeam = tournament.teams.find(t => t.starting_slot === startingSlot)
    this.seed = this.graphTeam.seed
    this.name = this.graphTeam.name

    let gameIndex = parseInt((this.startingSlot % 2 === 0 ? this.startingSlot : this.startingSlot - 1) / 2)
    this.firstGame = tree.gameNodes[gameIndex]
  }

  stillPlaying = () => {
    let game = this.firstGame
    while (game && game.decision) {
      if (game.winningTeamStartingSlot() !== this.startingSlot) return false
      game = game.parentGame()
    }
    return true
  }
}

App.SharedBracket = {
  populateBracket: function(bracketId, games) {
    this.bracketId = bracketId;
    this.games = games;
    this.championshipGame = _.find(this.games, {"nextGameId": null});

    this.fillInTeams();
    this.fillInPicks();
  },

  isChampionshipGame: function(game) {
    return this.championshipGame.id === game.id;
  },

  findGame: function(id) {
    return _.find(this.games, { "id": id });
  },

  fillInTeams: function() {
    _.each(this.games, this.fillInTeam.bind(this));
  },

  fillInTeam: function(game) {
    if (game.teamOne && game.teamTwo) {
      this.fillTeam(game.id, 1, game.teamOne);
      this.fillTeam(game.id, 2, game.teamTwo);
    }
  },

  fillInPicks: function() {
    _.each(this.games, this.fillInPick.bind(this));
  },

  fillInPick: function(game) {
    var team = this.pickTeam(game);
    if (team != null) {
      if (this.isChampionshipGame(game)) {
        this.fillChampionship(team);
      }
      else {
        this.fillTeam(game.nextGameId, game.nextSlot, team);
      }
    }
  },

  pickTeam: function(game) {
    if(game.choice == 0) {
      if(game.teamOne == null) {
        return this.pickTeam(this.findGame(game.gameOneId));
      }
      else {
        return game.teamOne;
      }
    } else if(game.choice == 1) {
      if (game.teamTwo == null) {
        return this.pickTeam(this.findGame(game.gameTwoId));
      }
      else {
        return game.teamTwo;
      }
    } else {
      return null;
    }
  },

  fillChampionship: function(team) {
    this.$championshipBox.html(team.name);
  },

  fillTeam: function(gameId, slot, team) {
    var slotHTML = '<span class="seed">' + team.seed + '</span>' + ' ' + team.name;
    $("#match" + gameId + ' > .slot' + slot).html(slotHTML);
  },

  updateEliminatedFlags: function() {
    _.each(this.games, this.updateEliminatedFlag.bind(this));
  },

  updateEliminatedFlag: function(game) {
    if (game.nextGameId != null && game.winningTeam != null) {
      var pickedTeam = this.pickTeam(game);
      if (game.winningTeam.id != pickedTeam.id) {
        pickedTeam.eliminated = true;
      }
    }
  }
};
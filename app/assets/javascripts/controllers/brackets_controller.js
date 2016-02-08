App.createController("Brackets", {
  actions: ["index", "edit", "show"],

  elements: {
    edit: {
      slots: ['.slot', {click: "handleSlotClick"}],
      championshipBox: ".champion-box"
    },
    show: {
      slots: '.slot', championshipBox: '.champion-box'
    }
  },

  index: function(bracketIds) {
    this.highlightBracketRows(bracketIds);
  },

  edit: function(bracketId, games) {
    this.bracketId = bracketId;
    this.games = games;
    this.championshipGame = _.findWhere(this.games, {"nextGameId": null});

    this.fillInTeams();
    this.fillInPicks();
  },

  show: function(bracketId, games) {
    this.bracketId = bracketId;
    this.games = games;
    this.championshipGame = _.findWhere(this.games, {"nextGameId": null});

    this.fillInTeams();
    this.fillInPicks();

    this.updateEliminatedFlags();
    this.highlightCorrectPicks();
  },

  isChampionshipGame: function(game) {
    return this.championshipGame.id === game.id;
  },

  findGame: function(id) {
    return _.findWhere(this.games, { "id": id });
  },

  handleSlotClick: function (event) {
    var eventTarget = $(event.currentTarget);
    var parentNode = eventTarget.offsetParent();
    var currentGameId = parseInt(parentNode[0].id.replace('match', ''));
    var currentGame = this.findGame(currentGameId);

    currentGame.choice = eventTarget.hasClass("slot1") ? 0 : 1;

    this.fillInPicks();

    $.ajax({
      url: '/brackets/' + this.bracketId + '/picks/' + currentGame.id,
      type: 'PATCH',
      data: { choice: currentGame.choice }
    });

  },

  fillInTeams: function() {
    _.each(this.games, this.fillInTeam);
  },

  fillInTeam: function(game) {
    if (game.teamOne && game.teamTwo) {
      this.fillTeam(game.id, 1, game.teamOne);
      this.fillTeam(game.id, 2, game.teamTwo);
    }
  },

  fillInPicks: function() {
    _.each(this.games, this.fillInPick);
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

  fillChampionship: function(team) {
    this.$championshipBox.html(team.name);
  },

  fillTeam: function(gameId, slot, team) {
    var slotHTML = '<span class="seed">' + team.seed + '</span>' + ' ' + team.name;
    $("#match" + gameId + ' > .slot' + slot).html(slotHTML);
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

  updateEliminatedFlags: function() {
    _.each(this.games, this.updateEliminatedFlag);
  },

  updateEliminatedFlag: function(game) {
    if (game.nextGameId != null && game.winningTeam != null) {
      var pickedTeam = this.pickTeam(game);
      if (game.winningTeam.id != pickedTeam.id) {
        pickedTeam.eliminated = true;
      }
    }
  },

  highlightBracketRows: function(bracketIds) {
    _.each(bracketIds, this.highlightBracketRow);
  },

  highlightBracketRow: function(bracketId) {
    $('#bracket-row-' + bracketId).addClass("current-user-bracket");
  },

  highlightCorrectPicks: function() {
    _.each(this.games, this.highlightCorrectPick);
    this.highlightChampionship();
  },

  highlightCorrectPick: function(game) {
    if (game.nextGameId != null) {
      var pickedTeam = this.pickTeam(game);
      var nextGame = this.findGame(game.nextGameId);
      var slotDiv = $("#match" + nextGame.id).find(".slot" + game.nextSlot);

      if (game.winningTeam != null && game.winningTeam.id == pickedTeam.id) {
          slotDiv.addClass("correct-pick");
      }
      else if (pickedTeam.eliminated === true) {
        slotDiv.addClass("eliminated");
      }
    }
  },

  highlightChampionship: function() {
    var pickedTeam = this.pickTeam(this.championshipGame);

    if (pickedTeam) {
      if (this.championshipGame.winningTeam && this.championshipGame.winningTeam.id == pickedTeam.id) {
          this.$championshipBox.addClass("correct-pick");
      }
      else if (pickedTeam.eliminated) {
        this.$championshipBox.addClass("eliminated");
      }
    }
  }
});
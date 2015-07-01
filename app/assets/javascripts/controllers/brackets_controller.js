App.createController("Brackets", {
  actions: ["index", "edit", "show"],

  index: function(bracketIds) {
    this.highlightBracketRows(bracketIds);
  },

  edit: function(bracketId, games) {
    this.bracketId = bracketId;
    this.games = games;
    this.championshipGame = _.findWhere(this.games, {"nextGameId": null});

    this.cacheElements();
    this.registerEvents();

    this.fillInPicks();
  },

  show: function(bracketId, games) {
    this.bracketId = bracketId;
    this.games = games;
    this.championshipGame = _.findWhere(this.games, {"nextGameId": null});

    this.cacheElements();
    this.fillInPicks();

    //this.strikeEliminatedTeams(eliminatedTeamIds);
    this.highlightCorrectPicks();
    //this.cleanupStrikesOnCorrectPicks();
  },

  cacheElements: function() {
    this.$slots = $('.slot');
    this.$championshipBox = $(".champion-box");
  },

  registerEvents: function() {
    this.$slots.click(this.handleSlotClick);
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
    if (game.winningTeam != null && game.nextGameId != null) {
      var pickedTeam = this.pickTeam(game);
      var nextGame = this.findGame(game.nextGameId);
      var slotDiv = $("#match" + nextGame.id).find(".slot" + game.nextSlot);
      if (game.winningTeam.id == pickedTeam.id) {
        slotDiv.addClass("correct-pick");
      }
      else {
        slotDiv.addClass("eliminated");
      }
    }
  },

  highlightChampionship: function() {
    if (this.championshipGame.winningTeam != null) {
      var pickedTeam = this.pickTeam(this.championshipGame);
      if (this.championshipGame.winningTeam.id == pickedTeam.id) {
        this.$championshipBox.addClass("correct-pick");
      }
      else {
        this.$championshipBox.addClass("eliminated");
      }
    }
  }
});
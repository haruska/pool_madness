App.createController("Brackets", {
  actions: ["index", "edit", "show"],

  index: function(bracketIds) {
    this.highlightBracketRows(bracketIds);
  },

  edit: function(gamesHash) {
    this.gamesHash = gamesHash;
    this.games = _.values(this.gamesHash);
    this.championshipGame = _.findWhere(this.games, {"nextGameId": null});

    this.fillInPicks();
    $('.slot').click(this.handleSlotClick);
  },

  show: function(eliminatedTeamIds, gamesPlayedSlots) {
    this.strikeEliminatedTeams(eliminatedTeamIds);
    this.highlightCorrectPicks(gamesPlayedSlots);
    this.cleanupStrikesOnCorrectPicks();
  },

  isChampionshipGame: function(game) {
    return this.championshipGame.id === game.id;
  },

  findGame: function(id) {
    return this.gamesHash[id];
  },

  handleSlotClick: function (event) {
    var eventTarget = $(event.currentTarget);
    var parentNode = eventTarget.offsetParent();
    var currentGameId = parseInt(parentNode[0].id.replace('match', ''));
    var currentGame = this.findGame(currentGameId);

    currentGame.choice = eventTarget.hasClass("slot1") ? 0 : 1;

    this.fillInPicks();

    $.ajax({
      url: '/picks/' + currentGame.pickId,
      type: 'PATCH',
      data: { pick: {choice: currentGame.choice} }
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
    $(".champion-box").html(team.name);
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

  strikeEliminatedTeams: function(eliminatedTeamIds) {
    _.each(eliminatedTeamIds, function(eliminatedTeamId) {
      $('.team' + eliminatedTeamId).addClass("eliminated");
    });
  },

  highlightCorrectPicks: function(gamesPlayedSlots) {
    _.each(gamesPlayedSlots, this.highlightCorrectPick);
  },

  highlightCorrectPick: function(gamePlayedSlot) {
    var gameId = gamePlayedSlot[0];
    var slotId = gamePlayedSlot[1];
    var teamId = gamePlayedSlot[2];

    var game = $('#match' + gameId);
    var slot = game.find(".slot" + slotId);
    if (slot.hasClass("team" + teamId)) {
      slot.addClass("correct-pick");
    }
  },

  cleanupStrikesOnCorrectPicks: function() {
    $(".eliminated.correct-pick").removeClass("eliminated");
  }
});
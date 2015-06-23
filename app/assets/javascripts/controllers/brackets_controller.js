App.createController("Brackets", {
  actions: ["index", "edit", "show"],

  index: function(bracketIds) {
    this.highlightBracketRows(bracketIds);
  },

  edit: function(games, teams) {
    this.games = games;
    this.teams = teams;

    $('.slot').click(this.handleSlotClick);
  },

  show: function(eliminatedTeamIds, gamesPlayedSlots) {
    this.strikeEliminatedTeams(eliminatedTeamIds);
    this.highlightCorrectPicks(gamesPlayedSlots);
    this.cleanupStrikesOnCorrectPicks();
  },

  championshipGame: function() {
    return _.findWhere(_.values(this.games), {"nextGameId": null});
  },

  isChampionshipGame: function(game) {
    return this.championshipGame().id === game.id;
  },

  findGame: function(id) {
    return this.games[id];
  },

  findTeam: function(id) {
    return this.teams[id];
  },

  highlightBracketRows: function(bracketIds) {
    _.each(bracketIds, this.highlightBracketRow);
  },

  highlightBracketRow: function(bracketId) {
    $('#bracket-row-' + bracketId).addClass("current-user-bracket");
  },

  handleSlotClick: function (event) {
    var parentNode = $(event.currentTarget).offsetParent();

    var currentGameId = parseInt(parentNode[0].id.replace('match', ''));
    var currentGame = this.findGame(currentGameId);

    var teamId = -1;
    var classList = $(event.currentTarget).attr('class').split(/\s+/);

    $.each(classList, function (index, item) {
      if (item.substring(0, 4) == 'team') {
        teamId = parseInt(item.replace('team', ''));
      }
    });

    if (this.isChampionshipGame(currentGame)) {

      var slotNode = $(".champion-box");

      slotNode.html($(event.currentTarget).html());

      //remove any old teamID classes
      var defunctClassList = slotNode.attr('class').split(/\s+/);
      $.each(defunctClassList, function (index, item) {
        if (item.substring(0, 4) == 'team') {
          slotNode.removeClass(item);
        }
      });

      //add this teamID
      slotNode.addClass("team" + teamId);
    }

    else {

      var nextGameId = currentGame.nextGameId;
      var nextSlot = currentGame.nextSlot;

      var slotNode = $("div#match" + nextGameId + " > .slot" + nextSlot);


      //get team in next slot
      var defunctTeamId = -1;
      var defunctClassList = slotNode.attr('class').split(/\s+/);
      $.each(defunctClassList, function (index, item) {
        if (item.substring(0, 4) == 'team') {
          defunctTeamId = parseInt(item.replace('team', ''));
        }
      });

      if (defunctTeamId > 0 && defunctTeamId != teamId) {
        this.clearSelection(currentGameId, nextGameId, defunctTeamId);
        this.clearChampionship(defunctTeamId);
      }


      slotNode.html($(event.currentTarget).html());
      slotNode.attr('class', 'slot slot' + nextSlot + ' team' + teamId);
    }

    $.ajax({
      url: '/picks/' + currentGame.pickId,
      type: 'POST',
      data: {_method: 'PUT', pick: {team_id: teamId}}

    });

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
  },

  clearSelection: function(prevGameId, fromGameId, teamId) {
    var slotNode = $("div#match" + fromGameId + " > .team" + teamId);

    var prevGame = this.findGame(prevGameId);
    var fromGame = this.findGame(fromGameId);

    if(slotNode[0] === undefined) {
      return;
    }
    else {
      slotNode.html(' ');
      slotNode.removeClass("team" + teamId);

      $.ajax({
        url: '/picks/' + prevGame.pickId,
        type: 'POST',
        data: { _method: 'PUT', pick: {team_id: -1}}

      });

      if(this.isChampionshipGame(fromGame)) {
        this.clearChampionship(teamId);
      }
      else {
        this.clearSelection(fromGameId, fromGame.nextGameId, teamId);
      }
    }
  },

  clearChampionship: function(teamId) {
    var champNode = $(".championship > .team" + teamId);
    if(champNode[0] === undefined) {
      return;
    }
    else {
      champNode.html(' ');
      champNode.removeClass("team" + teamId);

      $.ajax({
        url: '/picks/' + this.championshipGame().pickId,
        type: 'POST',
        data: { _method: 'PUT', pick: {team_id: -1}}
      });
    }
  }
});
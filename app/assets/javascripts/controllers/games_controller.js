App.createController("Games", {
  actions: ["index"],

  index: function(games) {
    this.games = games;
    this.championshipGame = _.findWhere(this.games, {"nextGameId": null});

    this.cacheElements();
    this.fillInPicks();
  },

  cacheElements: function() {
    this.$slots = $('.slot');
    this.$championshipBox = $(".champion-box");
  },

  isChampionshipGame: function(game) {
    return this.championshipGame.id === game.id;
  },

  findGame: function(id) {
    return _.findWhere(this.games, { "id": id });
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

  addEditLink: function() {
    var game_id = $(event.currentTarget)[0].id.replace('match', '');
    window.location = this.gamesPath + "/" + game_id + "/edit";
  },

  addEditGameClass: function() {
    $('.match').addClass('edit-game');
  }
});
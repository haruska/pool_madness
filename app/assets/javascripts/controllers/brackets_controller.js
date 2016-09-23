App.createController("Brackets", {
  actions: ["index", "edit", "show"],

  elements: {
    edit: {
      slots: ['.slot', {click: "handleSlotClick"}],
      championshipBox: ".champion-box"
    },
    show: {
      slots: '.slot',
      championshipBox: '.champion-box',
      tieBreakerValue: '.tie-breaker-value'
    }
  },

  index: function(bracketIds) {
    this.highlightBracketRows(bracketIds);
  },

  edit: function(bracketId, games) {
    this.mixinSharedBracket();
    this.populateBracket(bracketId, games);
  },

  show: function(bracketId, games, tieBreaker) {
    this.mixinSharedBracket();
    this.populateBracket(bracketId, games);

    this.updateEliminatedFlags();
    this.highlightCorrectPicks();
    this.fillInTieBreaker(tieBreaker);
  },

  fillInTieBreaker: function(value) {
    this.$tieBreakerValue.text(value);
  },

  mixinSharedBracket: function() {
    _.forEach(App.SharedBracket, function(func, name) {
      this[name] = func;
    }.bind(this));
  },

  handleSlotClick: function (event) {
    var eventTarget = $(event.currentTarget);
    var parentNode = eventTarget.offsetParent();
    var currentGameId = parseInt(parentNode[0].id.replace('match', ''));
    var currentGame = this.findGame(currentGameId);

    currentGame.choice = eventTarget.hasClass("slot1") ? 0 : 1;

    this.fillInPicks();

    $.ajax({
      url: '/brackets/' + this.bracketId + '/picks/' + currentGame.slot,
      type: 'PATCH',
      data: { choice: currentGame.choice }
    });

  },

  highlightBracketRows: function(bracketIds) {
    _.each(bracketIds, this.highlightBracketRow);
  },

  highlightBracketRow: function(bracketId) {
    $('.bracket-row-' + bracketId).addClass("current-user-bracket");
  },

  highlightCorrectPicks: function() {
    _.each(this.games, this.highlightCorrectPick);
    this.highlightChampionship();
  },

  highlightCorrectPick: function(game) {
    if (game.nextGameId != null) {
      var pickedTeam = this.pickTeam(game);
      var nextGame = this.findGame(game.nextGameId);
      var slotDiv = $("#match" + nextGame.slot).find(".slot" + game.nextSlot);

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
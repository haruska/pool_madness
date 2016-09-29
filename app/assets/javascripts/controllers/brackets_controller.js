App.createController("Brackets", {
  actions: ["index", "edit"],

  elements: {
    edit: {
      slots: ['.slot', {click: "handleSlotClick"}],
      championshipBox: ".champion-box"
    }
  },

  index: function(bracketIds) {
    this.highlightBracketRows(bracketIds);
  },

  edit: function(bracketId, games) {
    this.mixinSharedBracket();
    this.populateBracket(bracketId, games);
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
  }
});
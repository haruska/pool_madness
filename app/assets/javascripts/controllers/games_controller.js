App.createController("Games", {
  actions: ["index"],

  elements: {
    index: { slots: '.slot', championshipBox: '.champion-box' }
  },

  index: function(games) {
    this.mixinSharedBracket();
    this.populateBracket("", games);
  },

  mixinSharedBracket: function() {
    _.forEach(App.SharedBracket, function(func, name) {
      this[name] = func;
    }.bind(this));
  }
});
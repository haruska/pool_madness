App.createController("Games", {
  actions: ["index"],

  index: function(games) {
    bracketController = App.Controllers.Brackets;
    bracketController.show("", games);
  }
});
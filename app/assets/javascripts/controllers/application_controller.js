App.createController("Application", {
  elements: {
    all: {
      slidingButton: [
        ".sliding-panel-button,.sliding-panel-fade-screen,.sliding-panel-close",
        { "click touchstart": "toggleHamburger" }
      ],
      slidingContent: ".sliding-panel-content,.sliding-panel-fade-screen"
    }
  },

  toggleHamburger: function(e) {
    this.$slidingContent.toggleClass('is-visible');
    e.preventDefault();
  }
});

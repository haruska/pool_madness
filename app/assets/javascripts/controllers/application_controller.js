App.createController("Application", {
  all: function() {
    this.cacheElements();
    this.registerEvents();
  },

  cacheElements: function() {
    this.$slidingButton = $('.sliding-panel-button,.sliding-panel-fade-screen,.sliding-panel-close');
    this.$slidingContent = $('.sliding-panel-content,.sliding-panel-fade-screen');
  },

  registerEvents: function() {
    this.$slidingButton.on('click touchstart', this.toggleHamburger);

  },

  toggleHamburger: function(e) {
    this.$slidingContent.toggleClass('is-visible');
    e.preventDefault();
  }
});



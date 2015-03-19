App.createController("Games", {
    actions: ["index"],

    index: function(canEdit, gamesPath) {
        if(canEdit) {
            this.gamesPath = gamesPath;
            $('.match').click(this.addEditLink);
            $(document).ready(this.addEditGameClass);
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
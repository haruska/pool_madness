App.createController("Brackets", {
    actions: ["index", "edit"],

    index: function(bracket_ids) {
        $(document).ready(function() {
            _.each(bracket_ids, function(bracket_id) {
                $('#bracket-row-' + bracket_id).addClass("current-user-bracket");
            });
        });
    },

    edit: function(game_transitions, game_to_pick, champ_game_id) {
        this.game_to_pick = game_to_pick;
        this.game_transitions = game_transitions;
        this.champ_game_id = champ_game_id;

        $('.slot').click(this.handleSlotClick);
    },

    handleSlotClick: function (event) {

        var parent_node = $(event.currentTarget).offsetParent();

        var current_game_id = parseInt(parent_node[0].id.replace('match', ''));
        var transition = this.game_transitions[current_game_id];

        var team_id = -1;
        var classList = $(event.currentTarget).attr('class').split(/\s+/);
        $.each(classList, function (index, item) {
            if (item.substring(0, 4) == 'team') {
                team_id = parseInt(item.replace('team', ''));
            }
        });


        //championship
        if (transition === undefined) {

            var slot_node = $(".champion-box");

            slot_node.html($(event.currentTarget).html());

            //remove any old teamID classes
            var defunctClassList = slot_node.attr('class').split(/\s+/);
            $.each(defunctClassList, function (index, item) {
                if (item.substring(0, 4) == 'team') {
                    slot_node.removeClass(item);
                }
            });

            //add this teamID
            slot_node.addClass("team" + team_id);
        }

        else {

            var next_game_id = transition[0];
            var next_slot = transition[1];

            var slot_node = $("div#match" + next_game_id + " > .slot" + next_slot);


            //get team in next slot
            var defunct_team_id = -1;
            var defunctClassList = slot_node.attr('class').split(/\s+/);
            $.each(defunctClassList, function (index, item) {
                if (item.substring(0, 4) == 'team') {
                    defunct_team_id = parseInt(item.replace('team', ''));
                }
            });

            if (defunct_team_id > 0 && defunct_team_id != team_id) {
                this.clearSelection(current_game_id, next_game_id, defunct_team_id);
                this.clearChampionship(defunct_team_id);
            }


            slot_node.html($(event.currentTarget).html());
            slot_node.attr('class', 'slot slot' + next_slot + ' team' + team_id);
        }

        $.ajax({
            url: '/picks/' + this.game_to_pick[current_game_id],
            type: 'POST',
            data: {_method: 'PUT', pick: {team_id: team_id}}

        });

    },


    clearSelection: function(prev_game_id, from_game_id, team_id) {
        var slot_node = $("div#match" + from_game_id + " > .team" + team_id);
        if(slot_node[0] === undefined) {
            return;
        }
        else {
            slot_node.html(' ');
            slot_node.removeClass("team" + team_id);

            $.ajax({
                url: '/picks/' + this.game_to_pick[prev_game_id],
                type: 'POST',
                data: { _method: 'PUT', pick: {team_id: -1}}

            });

            if(this.game_transitions[from_game_id] === undefined) {
                this.clearChampionship(team_id);
            }
            else {
                this.clearSelection(from_game_id, this.game_transitions[from_game_id][0], team_id);
            }
        }
    },

    clearChampionship: function(team_id) {
        var champ_node = $(".championship > .team" + team_id);
        if(champ_node[0] === undefined) {
            return;
        }
        else {
            champ_node.html(' ');
            champ_node.removeClass("team" + team_id);

            $.ajax({
                url: '/picks/' + this.game_to_pick[this.champ_game_id],
                type: 'POST',
                data: { _method: 'PUT', pick: {team_id: -1}}

            });
        }
    }

});
var DuelTimer = /** @class */ (function () {
    function DuelTimer(parent, timeRemaining) {
        // Create new panel
        var panel = $.CreatePanel("Panel", parent, "");
        this.panel = panel;
        // Load snippet into panel
        panel.BLoadLayoutSnippet("DuelTimer");
        // Find components
        this.timerLabel = panel.FindChildTraverse("TimeRemaining");
        this.timerDescription = panel.FindChildTraverse("TimeLabel");
        /*this.killsNeededLabel = panel.FindChildTraverse("KillsNeeded") as LabelPanel;
        this.radiantKills = panel.FindChildTraverse("RadiantKills") as LabelPanel;
        this.direKills = panel.FindChildTraverse("DireKills") as LabelPanel;*/
        //TopBarRadiantScore
        var TopBarRadiantScore = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("TopBarRadiantScore");
        var TopBarDireScore = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("TopBarDireScore");
        /*this.killsNeededLabel.text = "Kills Needed To Win"

        this.radiantKills.text = ""
        this.direKills.text = ""
        */
        this.timerDescription.text = "Difficulty";
        this.started = false;
        // Set player name label
        //GameEvents.Subscribe("timer_player_death_radiant", (event) => this.OnTimerPlayerDeathRadiant(event));
        //GameEvents.Subscribe("timer_player_death_dire", (event) => this.OnTimerPlayerDeathDire(event));
        var canAlert = true;
    }
    DuelTimer.prototype.FancyTimeFormat = function (duration) {
        // Hours, minutes and seconds
        var hrs = ~~(duration / 3600);
        var mins = ~~((duration % 3600) / 60);
        var secs = ~~duration % 60;
        // Output like "1:01" or "4:03:59" or "123:03:59"
        var ret = "";
        if (hrs > 0) {
            ret += "" + hrs + ":" + (mins < 10 ? "0" : "");
        }
        ret += "" + mins + ":" + (secs < 10 ? "0" : "");
        ret += "" + secs;
        return ret;
    };
    DuelTimer.prototype.ToSeconds = function (fancy) {
        var minutes = parseInt(fancy.split(":")[0]);
        var seconds = parseInt(fancy.split(":")[1]);
        return (minutes * 60) + seconds;
    };
    // Set the health bar to a certain percentage (0-100)
    DuelTimer.prototype.UpdateTimer = function (difficulty) {
        this.timerLabel.text = difficulty;
    };
    DuelTimer.prototype.OnTimerPlayerDeathRadiant = function (data) {
        //this.radiantKills.text = `Angels: ${data.killsNeeded}`
    };
    DuelTimer.prototype.OnTimerPlayerDeathDire = function (data) {
        //this.direKills.text = `Demons: ${data.killsNeeded}`
    };
    DuelTimer.prototype.SetTimerLabel = function (time) {
        this.timerLabel.text = time;
    };
    DuelTimer.prototype.GetTimerLabel = function () {
        return this.timerLabel.text;
    };
    return DuelTimer;
}());

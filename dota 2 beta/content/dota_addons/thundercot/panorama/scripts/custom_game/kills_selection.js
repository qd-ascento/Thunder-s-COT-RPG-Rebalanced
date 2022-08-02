var KillsSelection = /** @class */ (function () {
    function KillsSelection(parent, t, amount) {
        // Create new panel
        var panel = $.CreatePanel("Panel", parent, "");
        this.panel = panel;
        // Load snippet into panel
        panel.BLoadLayoutSnippet("KillsSelection");
        // Find components
        this.amountLabel = panel.FindChildTraverse("DefaultValveButtonID");
        // Set player name label
        this.amountLabel.text = t;
        var btn = this.amountLabel;
        var _panel = this.panel;
        btn.SetPanelEvent("onmouseover", function () {
            switch (amount.toUpperCase()) {
                case "EASY":
                    $.DispatchEvent("DOTAShowTextTooltip", btn, $.Localize("#difficulty_easy_info"));
                    break;
                case "NORMAL":
                    $.DispatchEvent("DOTAShowTextTooltip", btn, $.Localize("#difficulty_normal_info"));
                    break;
                case "HARD":
                    $.DispatchEvent("DOTAShowTextTooltip", btn, $.Localize("#difficulty_hard_info"));
                    break;
                case "UNFAIR":
                    $.DispatchEvent("DOTAShowTextTooltip", btn, $.Localize("#difficulty_unfair_info"));
                    break;
                case "IMPOSSIBLE":
                    $.DispatchEvent("DOTAShowTextTooltip", btn, $.Localize("#difficulty_impossible_info"));
                    break;
                case "HELL":
                    $.DispatchEvent("DOTAShowTextTooltip", btn, $.Localize("#difficulty_infinity_info"));
                    break;
                case "HARDCORE":
                    $.DispatchEvent("DOTAShowTextTooltip", btn, $.Localize("#difficulty_hardcore_info"));
                    break;
            }
        });
        btn.SetPanelEvent("onmouseout", function () {
            $.DispatchEvent("DOTAHideTextTooltip", btn);
        });
        this.amountLabel.SetPanelEvent("onmouseactivate", function () {
            if (btn.disabled)
                return;
            GameEvents.SendCustomGameEventToServer("killvote", { option: amount });
            for (var _i = 0, _a = _panel.GetParent().FindChildrenWithClassTraverse("DefaultValveButtonClass"); _i < _a.length; _i++) {
                var b = _a[_i];
                b.disabled = true;
                b.AddClass("Clicked");
            }
            btn.AddClass("Chosen");
            var VotingDoneLabel = btn.GetParent().GetParent().GetParent().FindChildTraverse("HasVoted");
            VotingDoneLabel.text = "Waiting for game to start...";
            VotingDoneLabel.visible = true;
        });
    }
    return KillsSelection;
}());

var EffectSelection = /** @class */ (function () {
    function EffectSelection(parent, t, amount) {
        // Create new panel
        var panel = $.CreatePanel("Panel", parent, "");
        this.panel = panel;
        // Load snippet into panel
        panel.BLoadLayoutSnippet("EffectSelection");
        // Find components
        this.amountLabel = panel.FindChildTraverse("DefaultValveButtonIDEFFECT");
        // Set player name label
        this.amountLabel.text = t;
        var btn = this.amountLabel;
        var _panel = this.panel;
        btn.SetPanelEvent("onmouseover", function () {
            switch (amount.toUpperCase()) {
                case "ENABLE":
                    $.DispatchEvent("DOTAShowTextTooltip", btn, $.Localize("#effects_enabled_info"));
                    break;
                case "DISABLE":
                    $.DispatchEvent("DOTAShowTextTooltip", btn, $.Localize("#effects_disabled_info"));
                    break;
            }
        });
        btn.SetPanelEvent("onmouseout", function () {
            $.DispatchEvent("DOTAHideTextTooltip", btn);
        });
        this.amountLabel.SetPanelEvent("onmouseactivate", function () {
            if (btn.disabled)
                return;
            GameEvents.SendCustomGameEventToServer("effectvote", { option: amount });
            for (var _i = 0, _a = _panel.GetParent().FindChildrenWithClassTraverse("DefaultValveButtonClassEFFECT"); _i < _a.length; _i++) {
                var b = _a[_i];
                b.disabled = true;
                b.AddClass("Clicked");
            }
            btn.AddClass("Chosen");
            //let VotingDoneLabel = btn.GetParent().GetParent().GetParent().FindChildTraverse("HasVoted")
            //VotingDoneLabel.text = `Waiting for game to start...`
            //VotingDoneLabel.visible = true
        });
    }
    return EffectSelection;
}());

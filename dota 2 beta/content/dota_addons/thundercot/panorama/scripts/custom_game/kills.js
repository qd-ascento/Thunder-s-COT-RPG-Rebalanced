var KillsUI = /** @class */ (function () {
    function KillsUI(panel) {
        this.panel = panel;
        this.container = this.panel.FindChild("Kills");
        this.container.RemoveAndDeleteChildren();
        this.header = this.panel.FindChild("Header");
        this.instructions = this.panel.FindChild("Instructions");
        this.discord = this.instructions.FindChild("Discord");
        this.hasVotedText = this.instructions.FindChild("HasVoted");
        this.hasVotedText.visible = false;
        this.discord.SetPanelEvent("onmouseactivate", function () {
            $.DispatchEvent('ExternalBrowserGoToURL', 'https://discord.gg/A9G9qpYWWF');
        });
        this.header.text = $.Localize("#difficulty_select");
        this.timerPanel = new KillsSelection(this.container, $.Localize("#difficulty_easy"), "Easy");
        this.timerPanel2 = new KillsSelection(this.container, $.Localize("#difficulty_normal"), "Normal");
        this.timerPanel3 = new KillsSelection(this.container, $.Localize("#difficulty_hard"), "Hard");
        this.timerPanel4 = new KillsSelection(this.container, $.Localize("#difficulty_unfair"), "Unfair");
        this.timerPanel6 = new KillsSelection(this.container, $.Localize("#difficulty_impossible"), "Impossible");
        this.timerPanel5 = new KillsSelection(this.container, $.Localize("#difficulty_infinity"), "HELL");
        this.timerPanel5 = new KillsSelection(this.container, $.Localize("#difficulty_hardcore"), "HARDCORE");
        /// wave
        this.headerWave = this.panel.FindChild("HeaderVoteWave");
        this.containerWave = this.panel.FindChild("VoteForWave");
        this.headerWave.text = $.Localize("#waves_enabled");
        this.waveOption = new WaveSelection(this.containerWave, $.Localize("#waves_yes"), "Enable");
        this.waveOption2 = new WaveSelection(this.containerWave, $.Localize("#waves_no"), "Disable");
        // effects
        this.headerEffects = this.panel.FindChild("HeaderVoteEffects");
        this.containerEffects = this.panel.FindChild("VoteForEffects");
        this.headerEffects.text = $.Localize("#effects_enabled");
        this.effectOption = new EffectSelection(this.containerEffects, $.Localize("#effects_yes"), "Enable");
        this.effectOption2 = new EffectSelection(this.containerEffects, $.Localize("#effects_no"), "Disable");
        $.Msg(panel); // Print the panel
    }
    return KillsUI;
}());
var ui = new KillsUI($.GetContextPanel());

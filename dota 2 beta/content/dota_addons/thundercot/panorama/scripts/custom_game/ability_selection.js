var AbilitySelectionUI = /** @class */ (function () {
    // AbilitySelectionUI constructor
    function AbilitySelectionUI(panel) {
        var _this = this;
        this.onAbilityMenuReplace = function (_, _, res) {
            if (!res) {
                return;
            }
            if (res.userEntIndex != Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()))
                return;
            _this.panelContainer.RemoveAndDeleteChildren();
            for (var randomName in res.selection) {
                var ability = res.selection[randomName];
                if (_this.isValidAbility(ability)) {
                    var fnl = new AbilitySelectionContainer(_this.panelContainer, ability, res.userEntIndex, 2, res.oldAbility);
                }
            }
            return;
        };
        this.onAbilityMenuOpen = function (_, _, res) {
            if (!res) {
                return;
            }
            if (res.userEntIndex != Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()))
                return;
            _this.container.RemoveAndDeleteChildren();
            _this.panelContainer = $.CreatePanel("Panel", _this.container, "");
            _this.panelContainer.RemoveAndDeleteChildren();
            for (var name_1 in res.abilities) {
                var ability = res.abilities[name_1];
                if (_this.isValidAbility(ability)) {
                    var ab = new AbilitySelectionContainer(_this.panelContainer, ability, res.userEntIndex, 1, null);
                }
            }
            var cx = new AbilitySelectionContainer(_this.panelContainer, "ability_selection_cancel", res.userEntIndex, 3, null);
            return;
        };
        //
        this.onAbilityMenuSwap = function (_, _, res) {
            if (!res) {
                return;
            }
            if (res.userEntIndex != Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()))
                return;
            _this.container.RemoveAndDeleteChildren();
            _this.panelContainer = $.CreatePanel("Panel", _this.container, "");
            _this.panelContainer.RemoveAndDeleteChildren();
            _this.storedAbilities = [];
            for (var name_2 in res.abilities) {
                var ability = res.abilities[name_2];
                if (_this.isValidAbility(ability)) {
                    var ab = new AbilitySelectionContainer(_this.panelContainer, ability, res.userEntIndex, 4, null);
                    _this.storedAbilities.push(ability);
                }
            }
            var cx = new AbilitySelectionContainer(_this.panelContainer, "ability_selection_cancel", res.userEntIndex, 3, null);
            return;
        };
        this.onAbilityMenuSwapReplace = function (_, _, res) {
            if (!res) {
                return;
            }
            if (res.userEntIndex != Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()))
                return;
            _this.container.RemoveAndDeleteChildren();
            _this.panelContainer = $.CreatePanel("Panel", _this.container, "");
            _this.panelContainer.RemoveAndDeleteChildren();
            for (var _i = 0, _a = _this.storedAbilities; _i < _a.length; _i++) {
                var name_3 = _a[_i];
                var ability = name_3;
                if (_this.isValidAbility(ability)) {
                    var ab = new AbilitySelectionContainer(_this.panelContainer, ability, res.userEntIndex, 5, res.oldAbility);
                }
            }
            var cx = new AbilitySelectionContainer(_this.panelContainer, "ability_selection_cancel", res.userEntIndex, 3, null);
            return;
        };
        this.panel = panel;
        this.container = this.panel.FindChild("AbilitySelection");
        this.panelContainer = undefined;
        this.heroes = [
            "timbersaw",
            "gun_joe",
            "windranger",
            "alchemist",
            "ancient_apparition",
            "antimage",
            "axe",
            "bane",
            "beastmaster",
            "bloodseeker",
            "chen",
            "crystal_maiden",
            "dark_seer",
            "dazzle",
            "dragon_knight",
            "doom_bringer",
            "drow_ranger",
            "earthshaker",
            "enchantress",
            "enigma",
            "faceless_void",
            "furion",
            "juggernaut",
            "kunkka",
            "leshrac",
            "lich",
            "life_stealer",
            "lina",
            "lion",
            "mirana",
            "morphling",
            "necrolyte",
            "nevermore",
            "night_stalker",
            "omniknight",
            "puck",
            "pudge",
            "pugna",
            "rattletrap",
            "razor",
            "riki",
            "sand_king",
            "shadow_shaman",
            "slardar",
            "sniper",
            "spectre",
            "storm_spirit",
            "sven",
            "tidehunter",
            "tinker",
            "tiny",
            "vengefulspirit",
            "venomancer",
            "viper",
            "weaver",
            "windrunner",
            "witch_doctor",
            "zuus",
            "broodmother",
            "skeleton_king",
            "queenofpain",
            "huskar",
            "jakiro",
            "batrider",
            "warlock",
            "death_prophet",
            "ursa",
            "bounty_hunter",
            "silencer",
            "spirit_breaker",
            "invoker",
            "clinkz",
            "obsidian_destroyer",
            "shadow_demon",
            "lycan",
            "lone_druid",
            "brewmaster",
            "phantom_lancer",
            "treant",
            "ogre_magi",
            "chaos_knight",
            "phantom_assassin",
            "gyrocopter",
            "rubick",
            "luna",
            "wisp",
            "disruptor",
            "undying",
            "templar_assassin",
            "naga_siren",
            "nyx_assassin",
            "keeper_of_the_light",
            "visage",
            "meepo",
            "magnataur",
            "centaur",
            "slark",
            "shredder",
            "medusa",
            "troll_warlord",
            "tusk",
            "bristleback",
            "skywrath_mage",
            "elder_titan",
            "abaddon",
            "earth_spirit",
            "ember_spirit",
            "legion_commander",
            "phoenix",
            "terrorblade",
            "techies",
            "oracle",
            "winter_wyvern",
            "arc_warden",
            "abyssal_underlord",
            "monkey_king",
            "dark_willow",
            "pangolier",
            "grimstroke",
            "mars",
            "snapfire",
            "void_spirit",
            "hoodwink",
            "dawnbreaker",
            "marci",
            "primal_beast",
            "stargazer",
            "zaken",
            "stegius"
        ];
        this.storedAbilities = [];
        // Load snippet into panel
        CustomNetTables.SubscribeNetTableListener("ability_selection_open", this.onAbilityMenuOpen);
        CustomNetTables.SubscribeNetTableListener("ability_selection_open_replace", this.onAbilityMenuReplace);
        CustomNetTables.SubscribeNetTableListener("ability_selection_swap_position", this.onAbilityMenuSwap);
        CustomNetTables.SubscribeNetTableListener("ability_selection_swap_position_replace", this.onAbilityMenuSwapReplace);
        $.Msg(panel); // Print the panel
    }
    AbilitySelectionUI.prototype.isValidAbility = function (name) {
        for (var i = 0; i < this.heroes.length; i++) {
            if (name.startsWith(this.heroes[i])) {
                return true;
            }
        }
        return false;
    };
    return AbilitySelectionUI;
}());
var ui = new AbilitySelectionUI($.GetContextPanel());

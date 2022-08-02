var AbilitySelectionContainer = /** @class */ (function () {
    function AbilitySelectionContainer(parent, abilityName, userEntIndex, state, oldAbility) {
        // Create new panel
        var panel = $.CreatePanel("Panel", parent, "");
        this.panel = panel;
        // Load snippet into panel
        panel.BLoadLayoutSnippet("AbilitySelection");
        if (state == 1) {
            var ability = $.CreatePanelWithProperties("DOTAAbilityImage", this.panel, "", {
                "class": "ability",
                html: "true",
                selectionpos: "auto",
                hittest: "true",
                hittestchildren: "false",
                abilityname: abilityName,
                onmouseover: "DOTAShowAbilityTooltip('" + abilityName + "')",
                onmouseout: "DOTAHideAbilityTooltip()"
            });
            ability.SetPanelEvent("onactivate", function () {
                GameEvents.SendCustomGameEventToServer("ability_selection_change", { user: userEntIndex, ability: abilityName });
            });
        }
        else if (state == 2) {
            var ability = $.CreatePanelWithProperties("DOTAAbilityImage", this.panel, "", {
                "class": "ability",
                html: "true",
                selectionpos: "auto",
                hittest: "true",
                hittestchildren: "false",
                abilityname: abilityName,
                onmouseover: "DOTAShowAbilityTooltip('" + abilityName + "')",
                onmouseout: "DOTAHideAbilityTooltip()"
            });
            ability.SetPanelEvent("onactivate", function () {
                GameEvents.SendCustomGameEventToServer("ability_selection_change_final", { user: userEntIndex, ability: abilityName, oldAbility: oldAbility });
                panel.GetParent().GetParent().RemoveAndDeleteChildren();
            });
        }
        else if (state == 3) {
            var ability = $.CreatePanelWithProperties("DOTAAbilityImage", this.panel, "", {
                "class": "ability_cancel",
                html: "true",
                selectionpos: "auto",
                hittest: "true",
                hittestchildren: "false",
                abilityname: abilityName,
                onmouseover: "DOTAShowAbilityTooltip('" + abilityName + "')",
                onmouseout: "DOTAHideAbilityTooltip()"
            });
            ability.SetPanelEvent("onactivate", function () {
                panel.GetParent().GetParent().RemoveAndDeleteChildren();
            });
        }
        else if (state == 4) {
            var ability = $.CreatePanelWithProperties("DOTAAbilityImage", this.panel, "", {
                "class": "ability",
                html: "true",
                selectionpos: "auto",
                hittest: "true",
                hittestchildren: "false",
                abilityname: abilityName,
                onmouseover: "DOTAShowAbilityTooltip('" + abilityName + "')",
                onmouseout: "DOTAHideAbilityTooltip()"
            });
            ability.SetPanelEvent("onactivate", function () {
                GameEvents.SendCustomGameEventToServer("ability_selection_swap_position_final", { user: userEntIndex, ability: abilityName });
                panel.GetParent().GetParent().RemoveAndDeleteChildren();
            });
        }
        else if (state == 5) {
            var ability = $.CreatePanelWithProperties("DOTAAbilityImage", this.panel, "", {
                "class": "ability",
                html: "true",
                selectionpos: "auto",
                hittest: "true",
                hittestchildren: "false",
                abilityname: abilityName,
                onmouseover: "DOTAShowAbilityTooltip('" + abilityName + "')",
                onmouseout: "DOTAHideAbilityTooltip()"
            });
            ability.SetPanelEvent("onactivate", function () {
                GameEvents.SendCustomGameEventToServer("ability_selection_swap_position_final_complete", { user: userEntIndex, ability: abilityName, oldAbility: oldAbility });
                panel.GetParent().GetParent().RemoveAndDeleteChildren();
            });
        }
    }
    return AbilitySelectionContainer;
}());

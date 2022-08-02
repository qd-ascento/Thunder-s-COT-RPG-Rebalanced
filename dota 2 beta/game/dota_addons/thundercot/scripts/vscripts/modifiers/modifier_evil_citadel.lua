LinkLuaModifier("modifier_evil_citadel", "modifiers/modifier_evil_citadel.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_zeus_secret", "modifiers/modifier_evil_citadel.lua", LUA_MODIFIER_MOTION_NONE)

local BaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local BaseClassZeus = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return true end,
}

----
modifier_boss_zeus_secret = class(BaseClassZeus)
function modifier_boss_zeus_secret:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_boss_zeus_secret:IsHidden()
    return self:GetStackCount() < 1
end

function modifier_boss_zeus_secret:OnCreated()
    if not IsServer() then return end

    self:SetStackCount(_G.SummonedZeusDeaths)
end

function modifier_boss_zeus_secret:OnDeath(event)
    if event.unit ~= self:GetParent() then return end

    -- Kill him 3 times --
    if self:GetStackCount() < 3 then
        _G.SummonedZeusDeaths = _G.SummonedZeusDeaths + 1
    end

    if _G.SummonedZeusDeaths >= 3 then
        local heroes = HeroList:GetAllHeroes()
        for _,hero in ipairs(heroes) do
            if UnitIsNotMonkeyClone(hero) then
                if PlayerResource:GetConnectionState(hero:GetPlayerID()) == DOTA_CONNECTION_STATE_CONNECTED then
                    if hero:GetTeam() == event.attacker:GetTeam() then
                        if hero:FindItemInAnyInventory("item_zeus_soul") == nil then
                            hero:AddItemByName("item_zeus_soul")
                        end
                    end
                end
            end
        end
        --DropNeutralItemAtPositionForHero("item_zeus_soul", event.unit:GetAbsOrigin(), event.unit, 1, false)
    end
end

function modifier_boss_zeus_secret:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
----


evil_citadel = class(BaseClass)
modifier_evil_citadel = class(evil_citadel)

function DisableWaves()
    _G.bWavesEnabled = false
    CustomNetTables:SetTableValue("waves_disable", "game_info", {})

    if _G.SummonedZeus then return end
    CreateUnitByNameAsync("npc_dota_creature_150_boss_last", Entities:FindByName(nil, "spawn_boss_zeus"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
        unit:AddNewModifier(unit, nil, "modifier_unit_boss", {})
        unit:AddNewModifier(unit, nil, "modifier_unit_on_death", {
            posX = unit:GetAbsOrigin().x,
            posY = unit:GetAbsOrigin().y,
            posZ = unit:GetAbsOrigin().z,
            name = "npc_dota_creature_150_boss_last"
        })

        unit:AddNewModifier(unit, nil, "modifier_boss_zeus_secret", {})

        unit:AddNewModifier(unit, nil, "MODIFIER_STATE_CANNOT_MISS", {})
        unit:AddNewModifier(unit, nil, "MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED", {})
        _G.SummonedZeus = true

        GameRules:SendCustomMessage("<font color='red'>THE ALMIGHTY HEAVENLY FATHER HAS BLESSED US WITH HIS PRESENCE!!!</font>", 0, 0)
        GameRules:SendCustomMessage("<font color='red'>THE ALMIGHTY HEAVENLY FATHER HAS BLESSED US WITH HIS PRESENCE!!!</font>", 0, 0)
        GameRules:SendCustomMessage("<font color='red'>THE ALMIGHTY HEAVENLY FATHER HAS BLESSED US WITH HIS PRESENCE!!!</font>", 0, 0)
        GameRules:SendCustomMessage("<font color='red'>THE ALMIGHTY HEAVENLY FATHER HAS BLESSED US WITH HIS PRESENCE!!!</font>", 0, 0)
        GameRules:SendCustomMessage("<font color='red'>THE ALMIGHTY HEAVENLY FATHER HAS BLESSED US WITH HIS PRESENCE!!!</font>", 0, 0)
        GameRules:SendCustomMessage("<font color='red'>THE ALMIGHTY HEAVENLY FATHER HAS BLESSED US WITH HIS PRESENCE!!!</font>", 0, 0)
        GameRules:SendCustomMessage("<font color='red'>THE ALMIGHTY HEAVENLY FATHER HAS BLESSED US WITH HIS PRESENCE!!!</font>", 0, 0)
        GameRules:SendCustomMessage("<font color='red'>THE ALMIGHTY HEAVENLY FATHER HAS BLESSED US WITH HIS PRESENCE!!!</font>", 0, 0)
        GameRules:SendCustomMessage("<font color='red'>THE ALMIGHTY HEAVENLY FATHER HAS BLESSED US WITH HIS PRESENCE!!!</font>", 0, 0)
    end)
end
-------------
function evil_citadel:GetIntrinsicModifierName()
    return "modifier_evil_citadel"
end

function modifier_evil_citadel:OnCreated()
    if not IsServer() then return end
end

function modifier_evil_citadel:DeclareFunctions()
    local funcs = {
    }
end
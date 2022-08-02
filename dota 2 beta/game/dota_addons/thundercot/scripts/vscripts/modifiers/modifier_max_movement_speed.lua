LinkLuaModifier("modifier_max_movement_speed", "modifiers/modifier_max_movement_speed.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
}

max_movement_speed = class(ItemBaseClass)
modifier_max_movement_speed = class(max_movement_speed)

-----------------
function max_movement_speed:GetIntrinsicModifierName()
    return "modifier_max_movement_speed"
end
-----------------
function modifier_max_movement_speed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
    }

    return funcs
end

function modifier_max_movement_speed:GetModifierMoveSpeed_Limit()
    local caster = self:GetCaster()

    if caster:HasModifier("modifier_spirit_breaker_charge_of_darkness") then
        return 999999
    elseif caster:GetUnitName() == "npc_dota_hero_spirit_breaker" then
        return 2000
    else 
        return 2000
    end
end

function modifier_max_movement_speed:GetModifierIgnoreMovespeedLimit()
    return 1
end

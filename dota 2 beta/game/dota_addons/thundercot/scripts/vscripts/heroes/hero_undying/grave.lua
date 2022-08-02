LinkLuaModifier("modifier_undying_grave_custom", "heroes/hero_undying/grave.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undying_grave_custom_resurrecting", "heroes/hero_undying/grave.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassResurrecting = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return false end,
}

undying_grave_custom = class(ItemBaseClass)
modifier_undying_grave_custom = class(undying_grave_custom)
modifier_undying_grave_custom_resurrecting = class(ItemBaseClassResurrecting)
-------------
function undying_grave_custom:GetIntrinsicModifierName()
    return "modifier_undying_grave_custom"
end

function undying_grave_custom:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local ability = self
    local point = ability:GetCursorPosition()
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    
    CreateUnitByNameAsync("npc_dota_unit_tombstone_custom", point, true, nil, nil, caster:GetTeamNumber(), function(unit)
        unit:AddNewModifier(caster, nil, "modifier_invulnerable", {})
        Timers:CreateTimer(ability:GetSpecialValueFor("duration"), function()
            local tombstone = Entities:FindByModel(nil, "models/items/undying/idol_of_ruination/idol_tower.vmdl")
            if tombstone ~= nil then
                UTIL_RemoveImmediate(tombstone)
            end
        end)
    end)
end
------------
function modifier_undying_grave_custom_resurrecting:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_REINCARNATION 
    }
    return funcs
end

function modifier_undying_grave_custom_resurrecting:CheckState()
    local state = {
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true
    }   

    return state
end

function modifier_undying_grave_custom_resurrecting:ReincarnateTime()
    return 5.0
end

function modifier_undying_grave_custom_resurrecting:OnCreated(params)
    if not IsServer() then return end

    self.resPoint = Vector(params.x, params.y, params.z)
    --self:GetParent():SetRespawnPosition(self.resPoint)
end

function modifier_undying_grave_custom_resurrecting:OnDestroy()
    if not IsServer() then return end
    
    local tombstone = Entities:FindByModel(nil, "models/items/undying/idol_of_ruination/idol_tower.vmdl")
    if tombstone ~= nil then
        UTIL_RemoveImmediate(tombstone)
    end

    self:GetParent():RemoveNoDraw()
end
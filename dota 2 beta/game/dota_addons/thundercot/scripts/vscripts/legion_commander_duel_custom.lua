LinkLuaModifier("modifier_legion_commander_duel_custom", "legion_commander_duel_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_duel_custom_buff", "legion_commander_duel_custom.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}


local ItemBaseClassBuff = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return true end,
    IsDebuff = function(self) return false end,
}


legion_commander_duel_custom = class(ItemBaseClass)
modifier_legion_commander_duel_custom = class(legion_commander_duel_custom)
modifier_legion_commander_duel_custom_buff = class(ItemBaseClassBuff)
-------------
function legion_commander_duel_custom:GetIntrinsicModifierName()
    return "modifier_legion_commander_duel_custom"
end

function modifier_legion_commander_duel_custom_buff:DeclareFunctions()
    local funcs = { 
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_legion_commander_duel_custom:DeclareFunctions()
    local funcs = { 
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_legion_commander_duel_custom:OnDeath(event)
    if not IsServer() then return end
    if event.attacker ~= self:GetParent() or event.unit == self:GetParent() then return end

    local parent = self:GetParent()

    local buff = parent:FindModifierByName("modifier_legion_commander_duel_custom_buff")
    if buff == nil then
        parent:AddNewModifier(parent, self:GetAbility(), "modifier_legion_commander_duel_custom_buff", {}):SetStackCount(1)
    else
        buff:IncrementStackCount()
    end
end

function modifier_legion_commander_duel_custom_buff:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("damage_per_kill") * self:GetStackCount()
end

function modifier_legion_commander_duel_custom_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
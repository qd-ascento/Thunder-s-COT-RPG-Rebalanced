LinkLuaModifier("modifier_terrorblade_true_power_custom", "heroes/hero_terrorblade/terrorblade_true_power_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_terrorblade_true_power_custom_buff_permanent", "heroes/hero_terrorblade/terrorblade_true_power_custom.lua", LUA_MODIFIER_MOTION_NONE)

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


terrorblade_true_power_custom = class(ItemBaseClass)
modifier_terrorblade_true_power_custom = class(terrorblade_true_power_custom)
modifier_terrorblade_true_power_custom_buff_permanent = class(ItemBaseClassBuff)
-------------
function modifier_terrorblade_true_power_custom_buff_permanent:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_terrorblade_true_power_custom_buff_permanent:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, --GetModifierPreAttack_BonusDamage
    }

    return funcs
end

function modifier_terrorblade_true_power_custom_buff_permanent:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("damage_gain") * self:GetStackCount()
end
-------------
function terrorblade_true_power_custom:GetIntrinsicModifierName()
    return "modifier_terrorblade_true_power_custom"
end


function modifier_terrorblade_true_power_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH 
    }
    return funcs
end

function modifier_terrorblade_true_power_custom:OnCreated()
    self.parent = self:GetParent()
end

function modifier_terrorblade_true_power_custom:OnDeath(event)
    local unit = event.attacker
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local victim = event.unit

    if unit ~= parent then
        return
    end

    local ability = self:GetAbility()

    local buff = unit:FindModifierByNameAndCaster("modifier_terrorblade_true_power_custom_buff_permanent", unit)
    local stacks = unit:GetModifierStackCount("modifier_terrorblade_true_power_custom_buff_permanent", unit)
    
    if not buff then
        unit:AddNewModifier(unit, ability, "modifier_terrorblade_true_power_custom_buff_permanent", {})
    else
        buff:ForceRefresh()
    end

    unit:SetModifierStackCount("modifier_terrorblade_true_power_custom_buff_permanent", unit, (stacks + 1))
end
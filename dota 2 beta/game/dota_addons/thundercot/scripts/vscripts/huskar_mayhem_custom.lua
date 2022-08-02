LinkLuaModifier("modifier_huskar_mayhem_custom", "huskar_mayhem_custom.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

huskar_mayhem_custom = class(ItemBaseClass)
modifier_huskar_mayhem_custom = class(huskar_mayhem_custom)
-------------
function huskar_mayhem_custom:GetIntrinsicModifierName()
    return "modifier_huskar_mayhem_custom"
end

function huskar_mayhem_custom:OnUpgrade()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local maxHealthLimit = caster:GetMaxHealth() * (self:GetSpecialValueFor("max_hp_threshold") / 100)

    caster:SetHealth(maxHealthLimit)
end

function modifier_huskar_mayhem_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_RESPAWN,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

function modifier_huskar_mayhem_custom:GetModifierIncomingDamage_Percentage(event)
    return self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_huskar_mayhem_custom:GetModifierPreAttack_BonusDamage()
    return ((self:GetAbility():GetCaster():GetMaxHealth()) - (self:GetAbility():GetCaster():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("max_hp_threshold") / 100))) * self:GetAbility():GetSpecialValueFor("damage_per_missing_hp")
end

function modifier_huskar_mayhem_custom:OnRespawn()
    if not IsServer() then return end

    self.caster:SetHealth(self.maxHealthLimit)
end

function modifier_huskar_mayhem_custom:OnCreated()
    if not IsServer() then return end

    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    self.maxHealthLimit = self.caster:GetMaxHealth() * (self.ability:GetSpecialValueFor("max_hp_threshold") / 100)

    self.healthLost = self.caster:GetMaxHealth() - self.maxHealthLimit

    self.caster:SetHealth(self.maxHealthLimit)
end

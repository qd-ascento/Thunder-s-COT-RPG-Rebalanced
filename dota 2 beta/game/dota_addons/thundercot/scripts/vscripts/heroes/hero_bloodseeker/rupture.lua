LinkLuaModifier("modifier_bloodseeker_rupture_custom", "heroes/hero_bloodseeker/rupture.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_debuff", "heroes/hero_bloodseeker/rupture.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}
local ItemBaseClassDeBuff = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return true end,
    IsDebuff = function(self) return true end,
}

bloodseeker_rupture_custom = class(ItemBaseClass)
modifier_bloodseeker_rupture_custom = class(bloodseeker_rupture_custom)
modifier_bloodseeker_rupture_custom_debuff = class(ItemBaseClassDeBuff)
-------------
function modifier_bloodseeker_rupture_custom_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bloodseeker_rupture_custom_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, --GetModifierIncomingDamage_Percentage
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end

function modifier_bloodseeker_rupture_custom_debuff:OnTakeDamage(event)
    if not IsServer() then return end

    local victim = event.unit
    local attacker = event.attacker

    if victim ~= self:GetParent() then return end
    if victim:IsMagicImmune() or attacker:PassivesDisabled() then return end

    if event.inflictor ~= nil then
        if attacker:HasScepter() then return end
    else
        return
    end

    if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_stacks") then self:IncrementStackCount() self:ForceRefresh() else self:ForceRefresh() return end
end

function modifier_bloodseeker_rupture_custom_debuff:GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetSpecialValueFor("damage_increase_pct") * self:GetStackCount()
end

function modifier_bloodseeker_rupture_custom_debuff:GetEffectName()
    return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_bloodseeker_rupture_custom_debuff:OnCreated()
    if not IsServer() then return end

    local parent = self:GetParent()

    --EmitSoundOn("hero_bloodseeker.rupture_FP", parent)
end

function modifier_bloodseeker_rupture_custom_debuff:OnDestroy()
    if not IsServer() then return end

    local parent = self:GetParent()

    --StopSoundOn("hero_bloodseeker.rupture_FP", parent)
end
-------------
function bloodseeker_rupture_custom:GetIntrinsicModifierName()
    return "modifier_bloodseeker_rupture_custom"
end


function modifier_bloodseeker_rupture_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_bloodseeker_rupture_custom:OnCreated()
    self.parent = self:GetParent()
end

function modifier_bloodseeker_rupture_custom:OnAttackLanded(event)
    if not IsServer() then return end

    local victim = event.target
    local attacker = event.attacker

    if attacker ~= self:GetParent() then return end
    if victim:IsMagicImmune() or attacker:PassivesDisabled() then return end

    local mod = "modifier_bloodseeker_rupture_custom_debuff"
    if not victim:HasModifier(mod) then
        victim:AddNewModifier(attacker, self:GetAbility(), mod, { duration = self:GetAbility():GetSpecialValueFor("duration") }):SetStackCount(1)
        --EmitSoundOn("hero_bloodseeker.rupture.cast", victim)
    end
end


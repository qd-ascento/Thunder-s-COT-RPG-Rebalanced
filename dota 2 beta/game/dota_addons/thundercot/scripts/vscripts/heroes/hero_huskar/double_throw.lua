LinkLuaModifier("modifier_huskar_double_throw_custom", "heroes/hero_huskar/double_throw.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huskar_double_throw_custom_attack", "heroes/hero_huskar/double_throw.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

huskar_double_throw_custom = class(ItemBaseClass)
modifier_huskar_double_throw_custom = class(huskar_double_throw_custom)
modifier_huskar_double_throw_custom_attack = class(huskar_double_throw_custom)
-------------
function huskar_double_throw_custom:GetIntrinsicModifierName()
    return "modifier_huskar_double_throw_custom"
end

function modifier_huskar_double_throw_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_huskar_double_throw_custom:OnAttackLanded(event)
    if not IsServer() then return end

    local unit = event.attacker
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local victim = event.target

    if unit ~= parent then
        return
    end

    if not unit:IsAlive() or unit:PassivesDisabled() then
        return
    end

    local ability = self:GetAbility()
    local chance = ability:GetSpecialValueFor("chance")

    if RollPercentage(chance) and not unit:HasModifier("modifier_huskar_double_throw_custom_attack") then 
        unit:AddNewModifier(victim, ability, "modifier_huskar_double_throw_custom_attack", { duration = 0.1 })
    end
end
----
function modifier_huskar_double_throw_custom_attack:OnCreated()
    if not IsServer() then return end

    local victim = self:GetCaster()

    if not victim then return end
    if not victim:IsAlive() then return end

    local parent = self:GetParent()

    parent:PerformAttack(victim, true, true, true, false, true, false, false)
end
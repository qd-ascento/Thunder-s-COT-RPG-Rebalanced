LinkLuaModifier("modifier_item_armor_piercing_crossbow", "armor_piercing_crossbow.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_armor_piercing_crossbow_pierce", "armor_piercing_crossbow.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

item_armor_piercing_crossbow = class(ItemBaseClass)
item_armor_piercing_crossbow_2 = item_armor_piercing_crossbow
item_armor_piercing_crossbow_3 = item_armor_piercing_crossbow
item_armor_piercing_crossbow_4 = item_armor_piercing_crossbow
item_armor_piercing_crossbow_5 = item_armor_piercing_crossbow
modifier_item_armor_piercing_crossbow = class(ItemBaseClass)
modifier_item_armor_piercing_crossbow_pierce = class(ItemBaseClass)
-------------
function item_armor_piercing_crossbow:GetIntrinsicModifierName()
    return "modifier_item_armor_piercing_crossbow"
end

function modifier_item_armor_piercing_crossbow:CheckState()
    return {
        [MODIFIER_STATE_CANNOT_MISS] = true
    }
end

function modifier_item_armor_piercing_crossbow:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, --GetModifierPreAttack_BonusDamage
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, --GetModifierAttackSpeedBonus_Constant
    }
    return funcs
end

function modifier_item_armor_piercing_crossbow:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_armor_piercing_crossbow:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_armor_piercing_crossbow:OnCreated()
    if not IsServer() then return end
end

function modifier_item_armor_piercing_crossbow:OnAttackStart(event)
    local unit = event.attacker
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local victim = event.target

    if unit ~= parent then
        return
    end

    if not caster:IsAlive() or caster:IsMuted() then
        return
    end

    local ability = self:GetAbility()
    local pierceChance = ability:GetSpecialValueFor("pierce_chance")
    
    if RollPercentage(pierceChance) then
        --unit:AddNewModifier(unit, ability, "modifier_item_armor_piercing_crossbow_pierce", { duration = 1.5 })
    end
end

function modifier_item_armor_piercing_crossbow:GetModifierPreAttack_CriticalStrike(keys)
    local ability = self:GetAbility()

    if RollPercentage(ability:GetSpecialValueFor("crit_chance")) then
        keys.target:EmitSound("DOTA_Item.Daedelus.Crit")
        return ability:GetSpecialValueFor("crit_multiplier")
    end
end
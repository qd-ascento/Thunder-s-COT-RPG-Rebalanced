LinkLuaModifier("modifier_item_staff_of_dragons", "items/staff_of_dragons/staff_of_dragons.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_staff_of_dragons_debuff", "items/staff_of_dragons/staff_of_dragons.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassActive = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return false end,
}

local ItemDebuff = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return true end,
}

item_staff_of_dragons = class(ItemBaseClass)
item_staff_of_dragons_2 = item_staff_of_dragons
item_staff_of_dragons_3 = item_staff_of_dragons
item_staff_of_dragons_4 = item_staff_of_dragons
item_staff_of_dragons_5 = item_staff_of_dragons
item_staff_of_dragons_6 = item_staff_of_dragons
modifier_item_staff_of_dragons = class(ItemBaseClass)
modifier_item_staff_of_dragons_debuff = class(ItemDebuff)
function modifier_item_staff_of_dragons_debuff:GetTexture() return "staffofdragons" end
-------------
function item_staff_of_dragons:GetIntrinsicModifierName()
    return "modifier_item_staff_of_dragons"
end

function item_staff_of_dragons:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()

    if not caster:IsRangedAttacker() then DisplayError(caster:GetPlayerID(), "Only Works For Ranged Heroes.") return end

    local ability = self
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    
    caster:AddNewModifier(caster, ability, "modifier_item_staff_of_dragons_active", { duration = duration })
end
---
function modifier_item_staff_of_dragons_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS , --GetModifierMagicalResistanceBonus
    }
    return funcs
end

function modifier_item_staff_of_dragons_debuff:GetModifierMagicalResistanceBonus()
    return self:GetAbility():GetSpecialValueFor("magic_shred")
end
---

function modifier_item_staff_of_dragons:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, --GetModifierBonusStats_Intellect
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS, --GetModifierBonusStats_Agility
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE, -- GetModifierPercentageManaRegen
        MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE, -- GetModifierSpellLifestealRegenAmplify_Percentage
        MODIFIER_EVENT_ON_TAKEDAMAGE, --OnTakeDamage
    }

    return funcs
end

function modifier_item_staff_of_dragons:OnTakeDamage(event)
    if event.attacker ~= self:GetParent() then return end
    if event.attacker == event.unit then return end
    if event.damage_type ~= DAMAGE_TYPE_MAGICAL then return end

    local victim = event.unit

    victim:AddNewModifier(event.attacker, self:GetAbility(), "modifier_item_staff_of_dragons_debuff", {
        duration = self:GetAbility():GetSpecialValueFor("duration")
    })
end

function modifier_item_staff_of_dragons:GetModifierBonusStats_Intellect()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_item_staff_of_dragons:GetModifierBonusStats_Agility()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_staff_of_dragons:GetModifierSpellAmplify_Percentage()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_item_staff_of_dragons:GetModifierBonusStats_Strength()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_staff_of_dragons:GetModifierPercentageManaRegen()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("mana_regen_amp")
end

function modifier_item_staff_of_dragons:GetModifierSpellLifestealRegenAmplify_Percentage()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("spell_lifesteal_amp")
end
--

function modifier_item_staff_of_dragons:OnCreated()
    if not IsServer() then return end
end
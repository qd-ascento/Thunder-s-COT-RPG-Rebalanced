item_enchanted_armor = class({})
item_enchanted_armor2 = item_enchanted_armor
item_enchanted_armor3 = item_enchanted_armor
item_enchanted_armor4 = item_enchanted_armor
item_enchanted_armor5 = item_enchanted_armor

LinkLuaModifier("modifier_spell_lifesteal_uba", "modifiers/modifier_spell_lifesteal_uba.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_enchanted_armor", "enchanted_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_enchanted_armor_shield", "enchanted_armor.lua", LUA_MODIFIER_MOTION_NONE)

function item_enchanted_armor:GetIntrinsicModifierName() 
    return "modifier_item_enchanted_armor" 
end

local ItemBaseToggleClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsPurgeException = function(self) return false end,
}

modifier_item_enchanted_armor = class({})
modifier_item_enchanted_armor_shield = class(ItemBaseToggleClass)

---
function item_enchanted_armor:GetAbilityTextureName()
    if self:GetToggleState() then
        return "enchanted_armor_toggle"
    end

    if self:GetLevel() == 1 then
        return "enchanted_armor"
    elseif self:GetLevel() == 2 then
        return "enchanted_armor2"
    elseif self:GetLevel() == 3 then
        return "enchanted_armor3"
    elseif self:GetLevel() == 4 then
        return "enchanted_armor4"
    else
        return "enchanted_armor5"
    end
end

function item_enchanted_armor:ResetToggleOnRespawn()
    return true
end

function item_enchanted_armor:OnToggle()
    local caster = self:GetCaster()

    if self:GetToggleState() then
        EmitSoundOnLocationForPlayer("Hero_Medusa.ManaShield.On", caster:GetOrigin(), caster:GetPlayerID())
        caster:AddNewModifier(caster, self, "modifier_item_enchanted_armor_shield", {})
    else
        EmitSoundOnLocationForPlayer("Hero_Medusa.ManaShield.Off", caster:GetOrigin(), caster:GetPlayerID())
        caster:RemoveModifierByName("modifier_item_enchanted_armor_shield")
    end
end
---
function modifier_item_enchanted_armor:DeclareFunctions() 
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, --GetModifierBonusStats_Intellect
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, --GetModifierBonusStats_Strength
        MODIFIER_PROPERTY_HEALTH_BONUS, --GetModifierHealthBonus
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, --GetModifierAttackSpeedBonus_Constant
        MODIFIER_PROPERTY_MANA_BONUS, --GetModifierManaBonus
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
        MODIFIER_PROPERTY_MP_RESTORE_AMPLIFY_PERCENTAGE, -- GetModifierMPRestoreAmplify_Percentage
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, --GetModifierConstantManaRegen
        MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE, -- GetModifierSpellLifestealRegenAmplify_Percentage
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --GetModifierPhysicalArmorBonus
    } 
end

function modifier_item_enchanted_armor:IsHidden()
    return true
end

function modifier_item_enchanted_armor:OnCreated()
    if self:GetAbility() == nil then
        return
    end

    local caster = self:GetCaster()

    self.intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
    self.strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.health = self:GetAbility():GetSpecialValueFor("bonus_health")
    self.attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
    self.spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
    self.spell_lifesteal = self:GetAbility():GetSpecialValueFor("bonus_spell_lifesteal")
    self.mana_regen_amp = self:GetAbility():GetSpecialValueFor("bonus_mana_regen_amp")
    self.lifesteal_amp = self:GetAbility():GetSpecialValueFor("bonus_lifesteal_amp")
    self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.mana_regen_from_max = self:GetAbility():GetSpecialValueFor("mana_regen_from_max_mana_pct")

    if not IsServer() then return end

    Timers:CreateTimer(0.5, function() 
        caster:AddNewModifier(caster, ability, "modifier_spell_lifesteal_uba", { hero = self.spell_lifesteal, creep = self.spell_lifesteal })
    end)

    --self:StartIntervalThink(0.1)
end

function modifier_item_enchanted_armor:OnIntervalThink()
    local caster = self:GetCaster()

    if caster:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_INTELLECT then
        caster:DropItemAtPositionImmediate(self:GetAbility(), caster:GetAbsOrigin())
        DisplayError(caster:GetPlayerID(), "#primary_intellect_item")
    end

    self:StartIntervalThink(-1)
end

function modifier_item_enchanted_armor:OnRemoved()
    if not IsServer() then return end

    local caster = self:GetCaster()

    caster:RemoveModifierByNameAndCaster("modifier_spell_lifesteal_uba", caster)

    if caster:HasModifier("modifier_item_enchanted_armor_shield") then
        self:GetAbility():ToggleAbility()
        caster:RemoveModifierByNameAndCaster("modifier_item_enchanted_armor_shield", caster)
    end
end

function modifier_item_enchanted_armor:GetModifierBonusStats_Intellect() 
    return self.intellect
end

function modifier_item_enchanted_armor:GetModifierBonusStats_Strength() 
    return self.strength
end

function modifier_item_enchanted_armor:GetModifierHealthBonus() 
    return self.health
end

function modifier_item_enchanted_armor:GetModifierAttackSpeedBonus_Constant() 
    return self.attack_speed
end

function modifier_item_enchanted_armor:GetModifierManaBonus() 
    return self.mana
end

function modifier_item_enchanted_armor:GetModifierSpellAmplify_Percentage() 
    return self.spell_amp
end


function modifier_item_enchanted_armor:GetModifierConstantManaRegen() 
    return (self:GetParent():GetMaxMana() / 100) * self.mana_regen_from_max
end

function modifier_item_enchanted_armor:GetModifierMPRestoreAmplify_Percentage() 
    return self.mana_regen_amp
end

function modifier_item_enchanted_armor:GetModifierSpellLifestealRegenAmplify_Percentage() 
    return self.lifesteal_amp
end

function modifier_item_enchanted_armor:GetModifierPhysicalArmorBonus() 
    return self.armor
end
--------
function modifier_item_enchanted_armor_shield:GetEffectName()
    return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf"
end
LinkLuaModifier("modifier_undying_flesh_golem_custom", "heroes/hero_undying/flesh_golem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undying_flesh_golem_custom_aura", "heroes/hero_undying/flesh_golem.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClassAura = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
}

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

undying_flesh_golem_custom = class(ItemBaseClass)
modifier_undying_flesh_golem_custom = class(undying_flesh_golem_custom)
modifier_undying_flesh_golem_custom_aura = class(ItemBaseClassAura)

-------------
function undying_flesh_golem_custom:GetIntrinsicModifierName()
    return "modifier_undying_flesh_golem_custom"
end

function undying_flesh_golem_custom:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function modifier_undying_flesh_golem_custom:OnRefresh()
    self.str = self:GetParent():GetStrength() * (self:GetAbility():GetSpecialValueFor("str_pct")/100)
end

function modifier_undying_flesh_golem_custom:GetModifierModelChange()
    return "models/items/undying/flesh_golem/incurable_pestilence_golem/incurable_pestilence_golem.vmdl"
end

function modifier_undying_flesh_golem_custom:OnCreated()
    self.str = self:GetParent():GetStrength() * (self:GetAbility():GetSpecialValueFor("str_pct")/100)
end

function modifier_undying_flesh_golem_custom:GetEffectName()
    return "particles/units/heroes/hero_undying/undying_fg_aura.vpcf"
end

function modifier_undying_flesh_golem_custom:DeclareFunctions()
    local funcs = {
         MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, --GetModifierIncomingDamage_Percentage
         MODIFIER_PROPERTY_STATS_STRENGTH_BONUS , --GetModifierBonusStats_Strength
         MODIFIER_PROPERTY_MODEL_CHANGE 
    }
    return funcs
end

function modifier_undying_flesh_golem_custom:GetModifierBonusStats_Strength()
    return self.str
end

function modifier_undying_flesh_golem_custom:GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetSpecialValueFor("dmg_reduction_pct")
end

function modifier_undying_flesh_golem_custom:IsAura()
  return true
end

function modifier_undying_flesh_golem_custom:GetAuraSearchType()
  return bit.bor(DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO)
end

function modifier_undying_flesh_golem_custom:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_undying_flesh_golem_custom:GetAuraRadius()
  return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_undying_flesh_golem_custom:GetModifierAura()
    return "modifier_undying_flesh_golem_custom_aura"
end

function modifier_undying_flesh_golem_custom:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_undying_flesh_golem_custom:GetAuraEntityReject(target)
    return false
end
------
function modifier_undying_flesh_golem_custom_aura:OnCreated()
    local ability = self:GetAbility()
    
    if ability and not ability:IsNull() then
        self.slow = self:GetAbility():GetLevelSpecialValueFor("slow_pct", (self:GetAbility():GetLevel() - 1))
    end
end

function modifier_undying_flesh_golem_custom_aura:IsDebuff()
    return true
end

function modifier_undying_flesh_golem_custom_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, --GetModifierMoveSpeedBonus_Percentage
        MODIFIER_EVENT_ON_DEATH
    }

    return funcs
end

function modifier_undying_flesh_golem_custom_aura:OnDeath(event)
    if not IsServer() then return end
    if event.unit ~= self:GetParent() then return end
    if event.attacker ~= self:GetCaster() then return end


    local heal = event.unit:GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("heal_per_kill_pct")/100)
    self:GetCaster():Heal(heal, self:GetAbility())
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), heal, nil)
end

function modifier_undying_flesh_golem_custom_aura:GetModifierMoveSpeedBonus_Percentage()
    return self.slow or self:GetAbility():GetLevelSpecialValueFor("slow_pct", (self:GetAbility():GetLevel() - 1))
end
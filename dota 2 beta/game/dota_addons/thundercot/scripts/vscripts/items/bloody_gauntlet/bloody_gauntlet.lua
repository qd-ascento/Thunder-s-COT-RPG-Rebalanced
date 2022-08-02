LinkLuaModifier("modifier_item_bloody_gauntlet", "items/bloody_gauntlet/bloody_gauntlet.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bloody_gauntlet_active", "items/bloody_gauntlet/bloody_gauntlet.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bloody_gauntlet_emitter", "items/bloody_gauntlet/bloody_gauntlet.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bloody_gauntlet_emitter_aura", "items/bloody_gauntlet/bloody_gauntlet.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lifesteal_uba", "modifiers/modifier_lifesteal_uba.lua", LUA_MODIFIER_MOTION_NONE)

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

local ItemBaseAura = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return false end,
}

item_bloody_gauntlet = class(ItemBaseClass)
item_bloody_gauntlet_2 = item_bloody_gauntlet
item_bloody_gauntlet_3 = item_bloody_gauntlet
item_bloody_gauntlet_4 = item_bloody_gauntlet
item_bloody_gauntlet_5 = item_bloody_gauntlet
item_bloody_gauntlet_6 = item_bloody_gauntlet
modifier_item_bloody_gauntlet = class(ItemBaseClass)
modifier_item_bloody_gauntlet_active = class(ItemBaseClassActive)
modifier_item_bloody_gauntlet_emitter = class(ItemBaseClass)
modifier_item_bloody_gauntlet_emitter_aura = class(ItemBaseAura)
-------------
function item_bloody_gauntlet:GetIntrinsicModifierName()
    return "modifier_item_bloody_gauntlet"
end

function item_bloody_gauntlet:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local ability = self

    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))

    -- Create Placeholder Unit that holds the aura --
    local emitter = CreateUnitByName("outpost_placeholder_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
    emitter:AddNoDraw()
    emitter:AddNewModifier(caster, ability, "modifier_item_bloody_gauntlet_emitter", { 
        duration = duration, 
        radius = 300, 
        heal = ability:GetSpecialValueFor("puddle_max_hp_heal_pct"), 
        dpsIncreasePerSec = ability:GetSpecialValueFor("puddle_dps_increase_pct"), 
        interval = ability:GetSpecialValueFor("puddle_tick")    
    })
    -- --
    
    if caster:HasModifier("modifier_item_bloody_gauntlet_active") then
        caster:RemoveModifierByNameAndCaster("modifier_item_bloody_gauntlet_active", caster)
    end

    caster:AddNewModifier(caster, ability, "modifier_item_bloody_gauntlet_active", { duration = duration })
    EmitSoundOn("hero_bloodseeker.bloodRite", caster)
    EmitSoundOn("DOTA_Item.MaskOfMadness.Activate", caster)
end
---
function modifier_item_bloody_gauntlet_active:OnCreated()
    if not IsServer() then return end

    local caster = self:GetCaster()

    self.vfx = ParticleManager:CreateParticle("particles/units/heroes/hero_demonartist/demonartist_darkaspect_pool.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(self.vfx, 0, caster:GetOrigin())
end

function modifier_item_bloody_gauntlet_active:OnDestroy()
    if not IsServer() then return end

    ParticleManager:DestroyParticle( self.vfx, false )
    ParticleManager:ReleaseParticleIndex( self.vfx )
end

function modifier_item_bloody_gauntlet_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, --GetModifierAttackSpeedBonus_Constant
        
    }

    return funcs
end

function modifier_item_bloody_gauntlet_active:GetTexture()
    return "bloody_gauntlet"
end

function modifier_item_bloody_gauntlet_active:GetStatusEffectName()
    return "particles/econ/items/drow/drow_head_mania/mask_of_madness_active_mania.vpcf"
end

function modifier_item_bloody_gauntlet_active:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true
    }

    return state
end

function modifier_item_bloody_gauntlet_active:GetModifierAttackSpeedBonus_Constant()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end
---
function modifier_item_bloody_gauntlet:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, --GetModifierBonusStats_Strength
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, --GetModifierAttackSpeedBonus_Constant
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, --GetModifierPreAttack_BonusDamage
        MODIFIER_EVENT_ON_ATTACK_LANDED
        
    }

    return funcs
end

function modifier_item_bloody_gauntlet:OnRemoved()
    if not IsServer() then return end

    self:GetCaster():RemoveModifierByNameAndCaster("modifier_lifesteal_uba", self:GetCaster())
end

function modifier_item_bloody_gauntlet:OnAttackLanded(event)
    if not IsServer() then return end

    if event.attacker ~= self:GetParent() then return end

    local target = event.target
    local attacker = event.attacker
    local ability = self:GetAbility()

    local maxStacks = ability:GetSpecialValueFor("max_charges")

    if ability:GetCurrentCharges() >= maxStacks then return end
    if attacker:HasModifier("modifier_item_bloody_gauntlet_active") then return end

    ability:SetCurrentCharges(ability:GetCurrentCharges()+1)
end

function modifier_item_bloody_gauntlet:GetModifierBonusStats_Strength()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_bloody_gauntlet:GetModifierAttackSpeedBonus_Constant()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_bloody_gauntlet:GetModifierPreAttack_BonusDamage()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end
--

function modifier_item_bloody_gauntlet:OnCreated()
    if not IsServer() then return end

    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lifesteal_uba", { amount = self:GetAbility():GetSpecialValueFor("lifesteal") })
end
---
function modifier_item_bloody_gauntlet_emitter:OnCreated(params)
    if not IsServer() then return end

    local caster = self:GetCaster()
    local parent = self:GetParent()

    self.radius = params.radius
    self.duration = params.duration
    self.heal = params.heal
    self.dpsIncreasePerSec = params.dpsIncreasePerSec
    self.interval = params.interval

    -- Start the thinker to drain hp/do damage --
    self:StartIntervalThink(self.interval)
end

function modifier_item_bloody_gauntlet_emitter:OnIntervalThink()
    local caster = self:GetCaster()
    local parent = self:GetParent()

    local units = FindUnitsInRadius(caster:GetTeam(), parent:GetAbsOrigin(), nil,
        self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, bit.bor(DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC), DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST, false)

    for _,unit in ipairs(units) do
        local amount = ((caster:GetMaxHealth() * (self.heal/100)) * self:GetAbility():GetCurrentCharges()) * self.interval
        unit:Heal(amount, self:GetAbility())
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, amount, nil)
    end
end

function modifier_item_bloody_gauntlet_emitter:OnDestroy()
    if not IsServer() then return end

    self:GetParent():ForceKill(false)
    self:GetAbility():SetCurrentCharges(0)
end

function modifier_item_bloody_gauntlet_emitter:CheckState()
    local state = {
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true
    }   

    return state
end

function modifier_item_bloody_gauntlet_emitter:IsAura()
  return true
end

function modifier_item_bloody_gauntlet_emitter:GetAuraSearchType()
  return bit.bor(DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_CREEP)
end

function modifier_item_bloody_gauntlet_emitter:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_bloody_gauntlet_emitter:GetAuraRadius()
  return self.radius
end

function modifier_item_bloody_gauntlet_emitter:GetModifierAura()
    return "modifier_item_bloody_gauntlet_emitter_aura"
end

function modifier_item_bloody_gauntlet_emitter:GetAuraEntityReject(ent) 
    return false
end
--------------
function modifier_item_bloody_gauntlet_emitter_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }

    return funcs
end

function modifier_item_bloody_gauntlet_emitter_aura:OnCreated()
    if not IsServer() then return end

    self.dps = 0

    self:StartIntervalThink(1.0)
end

function modifier_item_bloody_gauntlet_emitter_aura:OnIntervalThink()
    self.dps = self.dps + self:GetAbility():GetSpecialValueFor("puddle_dps_increase_pct")
end

function modifier_item_bloody_gauntlet_emitter_aura:GetModifierDamageOutgoing_Percentage()
    if IsServer() then
        local amount = 100 + self.dps
        return amount
    end
end

function modifier_item_bloody_gauntlet_emitter_aura:GetTexture()
    return "bloody_gauntlet"
end
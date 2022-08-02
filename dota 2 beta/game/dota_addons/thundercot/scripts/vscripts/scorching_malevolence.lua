LinkLuaModifier("modifier_scorching_malevolence", "scorching_malevolence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_scorching_malevolence_burning", "scorching_malevolence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_scorching_malevolence_debuff_crit", "scorching_malevolence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_scorching_malevolence_debuff", "scorching_malevolence.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassAura = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
}

local ItemBaseDebuffClass = {
    IsPurgable = function(self) return true end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsDebuff = function(self) return true end,
    GetEffectAttachType = function() return PATTACH_OVERHEAD_FOLLOW end,
    GetEffectName =       function() return "particles/items2_fx/orchid.vpcf" end,
}

item_scorching_malevolence = class(ItemBaseClass)
item_scorching_malevolence2 = item_scorching_malevolence
item_scorching_malevolence3 = item_scorching_malevolence
item_scorching_malevolence4 = item_scorching_malevolence
modifier_scorching_malevolence = class(item_scorching_malevolence)
modifier_scorching_malevolence_debuff = class(ItemBaseDebuffClass)
modifier_scorching_malevolence_debuff_crit = class(ItemBaseClass)
modifier_scorching_malevolence_burning = class(ItemBaseClassAura)
-------------
function item_scorching_malevolence:GetIntrinsicModifierName()
    return "modifier_scorching_malevolence"
end

function item_scorching_malevolence:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorTarget()
    local duration = self:GetLevelSpecialValueFor("silence_duration", (self:GetLevel() - 1)) 

    target:AddNewModifier(target, ability, "modifier_scorching_malevolence_debuff", { duration = duration })

    EmitSoundOnLocationWithCaster(target:GetOrigin(), "DOTA_Item.Bloodthorn.Activate", target)
end
------------
function modifier_scorching_malevolence_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_NEGATIVE_EVASION_CONSTANT, --GetModifierNegativeEvasion_Constant   
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ATTACK_START, 
    }
    return funcs
end

function modifier_scorching_malevolence_debuff:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true
    }
    return state
end

function modifier_scorching_malevolence_debuff:OnTooltip()
    return self:GetAbility():GetSpecialValueFor("target_crit_multiplier")
end

if IsServer() then
    function modifier_scorching_malevolence_debuff:OnTakeDamage(keys)
        local parent = self:GetParent()
        if parent == keys.unit then
            ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit), 1, Vector(keys.damage))
            self.damage = (self.damage or 0) + keys.damage
        end
    end

    function modifier_scorching_malevolence_debuff:OnAttackStart(keys)
        local parent = self:GetParent()
        if parent == keys.target then
            local ability = self:GetAbility()
            keys.attacker:AddNewModifier(parent, self:GetAbility(), "modifier_scorching_malevolence_debuff_crit", {duration = 1.5})
        end
    end

    function modifier_scorching_malevolence_debuff:OnDestroy()
        local ability = self:GetAbility()
        local parent = self:GetParent()
        local damage = (self.damage or 0) * ability:GetSpecialValueFor("silence_damage_percent") * 0.01
        ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent), 1, Vector(damage))
        if damage > 0 then
            ApplyDamage({
                attacker = self:GetCaster(),
                victim = parent,
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                ability = ability
            })
        end
    end

    function modifier_scorching_malevolence_debuff_crit:DeclareFunctions()
        return {
            MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
            MODIFIER_EVENT_ON_ATTACK_LANDED
        }
    end

    function modifier_scorching_malevolence_debuff_crit:GetModifierPreAttack_CriticalStrike(keys)
        if keys.target == self:GetCaster() and keys.target:HasModifier("modifier_scorching_malevolence_debuff") then
            return self:GetAbility():GetSpecialValueFor("target_crit_multiplier")
        else
            self:Destroy()
        end
    end

    function modifier_scorching_malevolence_debuff_crit:OnAttackLanded(keys)
        if self:GetParent() == keys.attacker then
            keys.attacker:RemoveModifierByName("modifier_scorching_malevolence_debuff_crit")
        end
    end
end

function modifier_scorching_malevolence_debuff:OnCreated(params)
    if not IsServer() then return end
    self.damage = 0
end

function modifier_scorching_malevolence_debuff:GetModifierNegativeEvasion_Constant()
    return 9999
end
------------
function modifier_scorching_malevolence:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, --GetModifierBonusStats_Intellect
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,--GetModifierAttackSpeedBonus_Constant
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, --GetModifierPreAttack_BonusDamage
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, --GetModifierConstantManaRegen
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, --GetModifierMagicalResistanceBonus
        MODIFIER_PROPERTY_BONUS_DAY_VISION, --GetBonusDayVision
        MODIFIER_PROPERTY_EVASION_CONSTANT, --GetModifierEvasion_Constant
    }

    return funcs
end

function modifier_scorching_malevolence:OnIntervalThink()
    local caster = self:GetCaster()

    if caster:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_INTELLECT then
        caster:DropItemAtPositionImmediate(self:GetAbility(), caster:GetAbsOrigin())
        DisplayError(caster:GetPlayerID(), "#primary_intellect_item")
    end

    self:StartIntervalThink(-1)
end

if IsServer() then
    function modifier_scorching_malevolence:GetModifierPreAttack_CriticalStrike(k)
        local ability = self:GetAbility()
        if RollPercentage(ability:GetSpecialValueFor("tooltip_crit_chance")) then
            return ability:GetSpecialValueFor("tooltip_crit_chance")
        end
    end
end

function modifier_scorching_malevolence:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetLevelSpecialValueFor("bonus_intellect", (self:GetAbility():GetLevel() - 1))
end

function modifier_scorching_malevolence:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetLevelSpecialValueFor("bonus_attack_speed", (self:GetAbility():GetLevel() - 1))
end

function modifier_scorching_malevolence:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetLevelSpecialValueFor("bonus_damage", (self:GetAbility():GetLevel() - 1))
end

function modifier_scorching_malevolence:GetModifierConstantManaRegen()
    return self:GetAbility():GetLevelSpecialValueFor("bonus_mana_regen", (self:GetAbility():GetLevel() - 1))
end

function modifier_scorching_malevolence:GetModifierMagicalResistanceBonus()
    return self:GetAbility():GetLevelSpecialValueFor("bonus_magic_resist", (self:GetAbility():GetLevel() - 1))
end

function modifier_scorching_malevolence:GetBonusDayVision()
    return self:GetAbility():GetLevelSpecialValueFor("upgrade_day_vision", (self:GetAbility():GetLevel() - 1))
end

function modifier_scorching_malevolence:GetModifierEvasion_Constant()
    return self:GetAbility():GetLevelSpecialValueFor("evasion", (self:GetAbility():GetLevel() - 1))
end

function modifier_scorching_malevolence:IsAura()
  return true
end

function modifier_scorching_malevolence:GetAuraSearchType()
  return bit.bor(DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO)
end

function modifier_scorching_malevolence:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_scorching_malevolence:GetAuraRadius()
  return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_scorching_malevolence:GetModifierAura()
    return "modifier_scorching_malevolence_burning"
end

function modifier_scorching_malevolence:GetAuraEntityReject(target)
    return false
end

function modifier_scorching_malevolence:OnCreated()
    if not IsServer() then return end

    if IsServer() then
        self:StartIntervalThink(0.1)
    end
end

function modifier_scorching_malevolence:GetEffectName()
    return "particles/econ/events/ti6/radiance_owner_ti6.vpcf"
end
-----------------
function modifier_scorching_malevolence_burning:DeclareFunctions()
    local funcs = { 
        MODIFIER_PROPERTY_MISS_PERCENTAGE, --GetModifierMiss_Percentage
    }
    return funcs
end

function modifier_scorching_malevolence_burning:GetModifierMiss_Percentage()
    return self:GetAbility():GetLevelSpecialValueFor("blind_pct", (self:GetAbility():GetLevel() - 1))
end

function modifier_scorching_malevolence_burning:OnCreated()
    if not IsServer() then return end

    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()

    self:StartIntervalThink(self.ability:GetSpecialValueFor("aura_damage_interval"))
end

function modifier_scorching_malevolence_burning:OnIntervalThink()
    local burnDamage = self.ability:GetSpecialValueFor("aura_damage")

    if self.caster:IsIllusion() or self.caster:IsInvisible() then
        return
    end

    if self.parent:IsCreep() or self.parent:IsNeutralUnitType() then
        if self.parent:GetLevel() > self.caster:GetLevel() then return end
    end

    ApplyDamage({
        victim = self.parent, 
        attacker = self.caster, 
        damage = (self.parent:GetMaxHealth() * (burnDamage / 100)), 
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self.ability
    })

    ApplyDamage({
        victim = self.parent, 
        attacker = self.caster, 
        damage = self.ability:GetSpecialValueFor("aura_damage_flat"), 
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self.ability
    })
end

function modifier_scorching_malevolence_burning:GetEffectName()
    return "particles/econ/events/ti6/radiance_ti6.vpcf"
end
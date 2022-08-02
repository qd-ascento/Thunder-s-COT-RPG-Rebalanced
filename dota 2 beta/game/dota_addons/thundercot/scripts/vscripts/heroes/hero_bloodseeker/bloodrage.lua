LinkLuaModifier("modifier_bloodseeker_bloodrage_custom", "heroes/hero_bloodseeker/bloodrage.lua", LUA_MODIFIER_MOTION_NONE) --- PETH WEFY INPARFANT
LinkLuaModifier("modifier_bloodseeker_bloodrage_custom_buff", "heroes/hero_bloodseeker/bloodrage.lua", LUA_MODIFIER_MOTION_NONE) --- PETH WEFY INPARFANT
LinkLuaModifier("modifier_bloodseeker_bloodrage_custom_debuff", "heroes/hero_bloodseeker/bloodrage.lua", LUA_MODIFIER_MOTION_NONE) --- PETH WEFY INPARFANT
LinkLuaModifier("modifier_bloodseeker_bloodrage_custom_autocast", "heroes/hero_bloodseeker/bloodrage.lua", LUA_MODIFIER_MOTION_NONE) --- PETH WEFY INPARFANT

local AbilityClass = {
    IsPurgable = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
}

local AbilityClassBuff = {
    IsPurgable = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsDebuff = function(self) return false end,
}

local AbilityClassDebuff = {
    IsPurgable = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsDebuff = function(self) return true end,
}

bloodseeker_bloodrage_custom = class(AbilityClass)
modifier_bloodseeker_bloodrage_custom = class(AbilityClass)
modifier_bloodseeker_bloodrage_custom_buff = class(AbilityClassBuff)
modifier_bloodseeker_bloodrage_custom_debuff = class(AbilityClassDebuff)
modifier_bloodseeker_bloodrage_custom_autocast = class(AbilityClass)

function bloodseeker_bloodrage_custom:GetIntrinsicModifierName()
  return "modifier_bloodseeker_bloodrage_custom"
end

--
function modifier_bloodseeker_bloodrage_custom_autocast:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_bloodseeker_bloodrage_custom_autocast:OnDeath(event)
    local parent = self:GetParent()
    if parent ~= event.unit then return end
    local ability = parent:FindAbilityByName("bloodseeker_bloodrage_custom")
    if not ability or ability:GetLevel() < 1 or not ability:GetAutoCastState() then return end
    ability:ToggleAutoCast()
    parent:RemoveModifierByNameAndCaster("modifier_bloodseeker_bloodrage_custom_autocast", parent)
end

function modifier_bloodseeker_bloodrage_custom_autocast:OnCreated()
    if not IsServer() then return end

    self:StartIntervalThink(0.5)
end

function modifier_bloodseeker_bloodrage_custom_autocast:IsHidden()
    return true
end

function modifier_bloodseeker_bloodrage_custom_autocast:RemoveOnDeath()
    return false
end

function modifier_bloodseeker_bloodrage_custom_autocast:OnIntervalThink()
    if self:GetParent():IsChanneling() then return end
    
    if self:GetAbility():GetAutoCastState() and self:GetAbility():IsFullyCastable() and self:GetAbility():IsCooldownReady() then
        self:GetAbility():CastAbility()
        --self:GetParent():CastAbilityOnTarget(self:GetParent(), self:GetAbility(), 1)
        --self:GetAbility():UseResources(true, false, true)
    end
end
--
function bloodseeker_bloodrage_custom:OnSpellStart()
    if not IsServer() then return end
--
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()
    local ability = self
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))

    if not target or target:IsNull() then
        target = self:GetCaster()
    end

    if not target:IsAlive() then return end 

    target:AddNewModifier(caster, ability, "modifier_bloodseeker_bloodrage_custom_buff", { duration = duration })
    target:AddNewModifier(caster, ability, "modifier_bloodseeker_bloodrage_custom_debuff", { duration = duration })

    CreateParticleWithTargetAndDuration("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf", target, duration)
    EmitSoundOnLocationWithCaster(caster:GetOrigin(), "hero_bloodseeker.bloodRage", caster)
end
---------------------
function modifier_bloodseeker_bloodrage_custom_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, --GetModifierAttackSpeedBonus_Constant
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_bloodseeker_bloodrage_custom_buff:OnAttackLanded(event)
    if not IsServer() then return end

    local parent = self:GetParent()
    local target = event.target

    if event.attacker ~= parent then return end
    if not parent:HasModifier("modifier_item_aghanims_shard") then return end
    if parent ~= self:GetCaster() or target:IsBuilding() then return end -- Doesn't work on bosses and only works when cast on bloodseeker

    local shardPct = self:GetAbility():GetLevelSpecialValueFor("shard_damage_pct", (self:GetAbility():GetLevel() - 1)) / 100
    local extraDamage = target:GetMaxHealth() * shardPct

    if IsBossTCOTRPG(target) then
        extraDamage = target:GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("shard_damage_pct_boss")/100)
    end

    local damage = {
        victim = target,
        attacker = parent,
        damage = extraDamage,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
    }

    ApplyDamage(damage)
    parent:Heal(extraDamage, self:GetAbility())
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, extraDamage, nil)
end

function modifier_bloodseeker_bloodrage_custom_buff:OnCreated()
    self.attack_speed = self:GetAbility():GetLevelSpecialValueFor("attack_speed", (self:GetAbility():GetLevel() - 1))
    self.attack_speed_ally = self:GetAbility():GetLevelSpecialValueFor("attack_speed_ally", (self:GetAbility():GetLevel() - 1))

    if self:GetCaster() ~= self:GetParent() then
        self.attack_speed = self.attack_speed_ally
    end
end

function modifier_bloodseeker_bloodrage_custom_buff:GetModifierAttackSpeedBonus_Constant()
    return self.attack_speed
end

function modifier_bloodseeker_bloodrage_custom_buff:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetLevelSpecialValueFor("spell_amp", (self:GetAbility():GetLevel() - 1))
end

function modifier_bloodseeker_bloodrage_custom_buff:GetTexture()
    return "bloodseeker_bloodrage"
end
-------------------
function modifier_bloodseeker_bloodrage_custom_debuff:OnCreated()
    if not IsServer() then return end

    self.damage_pct = self:GetAbility():GetLevelSpecialValueFor("damage_pct", (self:GetAbility():GetLevel() - 1))

    self:StartIntervalThink(0.5)
end

function modifier_bloodseeker_bloodrage_custom_debuff:OnIntervalThink()
    local parent = self:GetParent()
    local ability = self:GetAbility()

    if not parent:IsAlive() or parent:GetHealth() < 1 then
        self:StartIntervalThink(-1)
        return
    end

    local drain = parent:GetMaxHealth() * ((self.damage_pct/2)/100)

    local damage = {
        victim = parent,
        attacker = parent,
        damage = drain,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NON_LETHAL,
    }

    ApplyDamage(damage)
end
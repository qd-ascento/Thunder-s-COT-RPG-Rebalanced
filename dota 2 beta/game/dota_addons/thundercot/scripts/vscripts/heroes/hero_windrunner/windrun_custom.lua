windranger_windrun_custom = class({})
modifier_windranger_windrun_custom_autocast = class({})
LinkLuaModifier( "modifier_windranger_windrun_custom", "heroes/hero_windrunner/windrun_custom.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_windranger_windrun_custom_autocast", "heroes/hero_windrunner/windrun_custom.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_windranger_windrun_custom_debuff", "heroes/hero_windrunner/windrun_custom.lua", LUA_MODIFIER_MOTION_NONE )

function modifier_windranger_windrun_custom_autocast:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_windranger_windrun_custom_autocast:OnDeath(event)
    local parent = self:GetParent()
    if parent ~= event.unit then return end
    local windrun = parent:FindAbilityByName("windrunner_windrun")
    if not windrun or windrun:GetLevel() < 1 or not windrun:GetAutoCastState() then return end
    windrun:ToggleAutoCast()
    parent:RemoveModifierByNameAndCaster("modifier_windranger_windrun_custom_autocast", parent)
end

function modifier_windranger_windrun_custom_autocast:OnCreated()
    if not IsServer() then return end

    self:StartIntervalThink(0.5)
end

function modifier_windranger_windrun_custom_autocast:IsHidden()
    return true
end

function modifier_windranger_windrun_custom_autocast:RemoveOnDeath()
    return false
end

function modifier_windranger_windrun_custom_autocast:OnIntervalThink()
    if self:GetParent():IsChanneling() then return end
    if self:GetAbility():GetAutoCastState() and self:GetAbility():IsFullyCastable() and self:GetAbility():IsCooldownReady() then
        self:GetParent():CastAbilityImmediately(self:GetAbility(), 1)
        self:GetAbility():UseResources(true, false, true)
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function windranger_windrun_custom:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()

    -- load data
    local duration = self:GetSpecialValueFor( "duration" )

    -- add modifier
    caster:AddNewModifier(
        caster, -- player source
        self, -- ability source
        "modifier_windranger_windrun_custom", -- modifier name
        { duration = duration } -- kv
    )

    -- Play effects
    local sound_cast = "Ability.Windrun"
    EmitSoundOn( sound_cast, caster )
end

modifier_windranger_windrun_custom = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_windranger_windrun_custom:IsHidden()
    return false
end

function modifier_windranger_windrun_custom:IsDebuff()
    return false
end

function modifier_windranger_windrun_custom:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_windranger_windrun_custom:OnCreated( kv )
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    self.evasion = self:GetAbility():GetSpecialValueFor( "evasion_pct_tooltip" )
    self.ms_bonus = self:GetAbility():GetSpecialValueFor( "movespeed_bonus_pct" )

    self.aura_duration = 2.5

    if self:GetCaster():HasScepter() then
        local ms_bonus_scepter = self:GetAbility():GetSpecialValueFor( "scepter_bonus_movement" )
        self.ms_bonus = self.ms_bonus + ms_bonus_scepter
    end

    if IsServer() then
    end
end



function modifier_windranger_windrun_custom:OnRefresh( kv )
    -- same as oncreated
    self:OnCreated( kv )
end

function modifier_windranger_windrun_custom:OnRemoved()
end

function modifier_windranger_windrun_custom:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_windranger_windrun_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
    }

    return funcs
end

function modifier_windranger_windrun_custom:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_bonus
end
function modifier_windranger_windrun_custom:GetModifierEvasion_Constant()
    return self.evasion
end

-- --------------------------------------------------------------------------------
-- -- Status Effects
-- function modifier_windranger_windrun_custom:CheckState()
--  local state = {
--      [MODIFIER_STATE_INVULNERABLE] = true,
--  }

--  return state
-- end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_windranger_windrun_custom:IsAura()
    return true
end

function modifier_windranger_windrun_custom:GetModifierAura()
    return "modifier_windranger_windrun_custom_debuff"
end

function modifier_windranger_windrun_custom:GetAuraRadius()
    return self.radius
end

function modifier_windranger_windrun_custom:GetAuraDuration()
    return self.aura_duration
end

function modifier_windranger_windrun_custom:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_windranger_windrun_custom:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_windranger_windrun_custom:GetEffectName()
    return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
end

function modifier_windranger_windrun_custom:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_windranger_windrun_custom_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_windranger_windrun_custom_debuff:IsHidden()
    return false
end

function modifier_windranger_windrun_custom_debuff:IsDebuff()
    return true
end

function modifier_windranger_windrun_custom_debuff:IsStunDebuff()
    return false
end

function modifier_windranger_windrun_custom_debuff:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_windranger_windrun_custom_debuff:OnCreated( kv )
    -- references
    self.slow = self:GetAbility():GetSpecialValueFor( "enemy_movespeed_bonus_pct" )
end

function modifier_windranger_windrun_custom_debuff:OnRefresh( kv )
    -- references
    self.slow = self:GetAbility():GetSpecialValueFor( "enemy_movespeed_bonus_pct" )
end

function modifier_windranger_windrun_custom_debuff:OnRemoved()
end

function modifier_windranger_windrun_custom_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_windranger_windrun_custom_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_windranger_windrun_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_windranger_windrun_custom_debuff:GetEffectName()
    return "particles/units/heroes/hero_windrunner/windrunner_windrun_slow.vpcf"
end

function modifier_windranger_windrun_custom_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
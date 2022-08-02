silencer_glaives_of_wisdom_custom = class({})
LinkLuaModifier( "modifier_generic_orb_effect_lua", "modifiers/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_glaives_of_wisdom_custom", "heroes/hero_silencer/glaives", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function silencer_glaives_of_wisdom_custom:GetIntrinsicModifierName()
    return "modifier_silencer_glaives_of_wisdom_custom"
end
--------------------------------------------------------------------------------
-- Ability Cast Filter
function silencer_glaives_of_wisdom_custom:CastFilterResultTarget( hTarget )
    local flag = 0
    local nResult = UnitFilter(
        hTarget,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
        flag,
        self:GetCaster():GetTeamNumber()
    )
    if nResult ~= UF_SUCCESS then
        return nResult
    end

    return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Start
function silencer_glaives_of_wisdom_custom:OnSpellStart()
end

--------------------------------------------------------------------------------
-- Orb Effects
function silencer_glaives_of_wisdom_custom:GetProjectileName()
    return "particles/units/heroes/hero_silencer/silencer_glaives_of_wisdom.vpcf"
end

function silencer_glaives_of_wisdom_custom:OnOrbFire( params )
    -- play effects
    local sound_cast = "Hero_Silencer.GlaivesOfWisdom"
    EmitSoundOn( sound_cast, self:GetCaster() )
end

function silencer_glaives_of_wisdom_custom:OnOrbImpact( params )
    local caster = self:GetCaster()

    -- get damage
    local int_mult = self:GetSpecialValueFor( "intellect_damage_pct" )
    local damage = caster:GetIntellect() * int_mult/100

    -- apply damage
    local damageTable = {
        victim = params.target,
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self, --Optional.
    }
    ApplyDamage(damageTable)

    -- overhead message
    SendOverheadEventMessage(
        nil,
        OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
        params.target,
        damage,
        nil
    )

    -- play effects
    local sound_cast = "Hero_Silencer.GlaivesOfWisdom.Damage"
    EmitSoundOn( sound_cast, params.target )
end

modifier_silencer_glaives_of_wisdom_custom = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_silencer_glaives_of_wisdom_custom:IsHidden()
    return false
end

function modifier_silencer_glaives_of_wisdom_custom:IsDebuff()
    return false
end

function modifier_silencer_glaives_of_wisdom_custom:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_silencer_glaives_of_wisdom_custom:OnCreated( kv )
    self.steal = 2

    if not IsServer() then return end

    -- create generic orb effect
    self:GetParent():AddNewModifier(
        self:GetCaster(), -- player source
        self:GetAbility(), -- ability source
        "modifier_generic_orb_effect_lua", -- modifier name
        {  } -- kv
    )
end

function modifier_silencer_glaives_of_wisdom_custom:OnRefresh( kv )
    self.steal = 2

    if not IsServer() then return end
end

function modifier_silencer_glaives_of_wisdom_custom:OnRemoved()
end

function modifier_silencer_glaives_of_wisdom_custom:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects


--------------------------------------------------------------------------------
-- Helper
function modifier_silencer_glaives_of_wisdom_custom:Steal( target )
    -- get steal number
    local steal = self.steal
    local target_int = target:GetBaseIntellect()
    if target_int<=1 then
        steal = 0
    elseif target_int-steal<1 then
        steal = target_int-1
    end

    -- steal
    self:GetParent():SetBaseIntellect( self:GetParent():GetBaseIntellect() + steal )
    target:SetBaseIntellect( target_int - steal )

    -- increment count
    self:SetStackCount( self:GetStackCount() + steal )

    -- overhead event
    SendOverheadEventMessage(
        nil,
        OVERHEAD_ALERT_MANA_ADD,
        self:GetParent(),
        steal,
        nil
    )
    SendOverheadEventMessage(
        nil,
        OVERHEAD_ALERT_MANA_LOSS,
        target,
        steal,
        nil
    )
end
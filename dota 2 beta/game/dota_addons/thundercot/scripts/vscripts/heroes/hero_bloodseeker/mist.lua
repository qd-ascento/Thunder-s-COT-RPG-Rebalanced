LinkLuaModifier("modifier_bloodseeker_blood_mist_custom", "heroes/hero_bloodseeker/mist.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_mist_custom_buff", "heroes/hero_bloodseeker/mist.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_blood_mist_custom_buff_aura", "heroes/hero_bloodseeker/mist.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_rupture_custom_debuff", "heroes/hero_bloodseeker/rupture.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassBuff = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return false end,
}

local ItemBaseClassAura = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
}

bloodseeker_blood_mist_custom = class(ItemBaseClass)
modifier_bloodseeker_blood_mist_custom = class(bloodseeker_blood_mist_custom)
modifier_bloodseeker_blood_mist_custom_buff = class(ItemBaseClassBuff)
modifier_bloodseeker_blood_mist_custom_buff_aura = class(ItemBaseClassAura)
-------------
function bloodseeker_blood_mist_custom:GetIntrinsicModifierName()
    return "modifier_bloodseeker_blood_mist_custom"
end

function bloodseeker_blood_mist_custom:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function bloodseeker_blood_mist_custom:OnSpellStart()
    if not IsServer() then return end
--
    local caster = self:GetCaster()
    local ability = self
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    
    caster:AddNewModifier(caster, ability, "modifier_bloodseeker_blood_mist_custom_buff", { duration = duration })
end
------------
function modifier_bloodseeker_blood_mist_custom_buff:DeclareFunctions()
    local funcs = {
         
    }

    return funcs
end

function modifier_bloodseeker_blood_mist_custom_buff:IsAura() return true end

function modifier_bloodseeker_blood_mist_custom_buff:OnCreated()
    if not IsServer() then return end

    local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf"
    local sound_cast = "Hero_Boodseeker.Bloodmist"
    local radius = self:GetAbility():GetSpecialValueFor( "radius" )

    -- Create Particle
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, radius, radius ) )

    -- Create Sound
    EmitSoundOn( sound_cast, self:GetParent() )
    self:StartIntervalThink(GameRules:GetGameFrameTime())
end

function modifier_bloodseeker_blood_mist_custom_buff:OnDestroy()
    if not IsServer() then return end

    ParticleManager:DestroyParticle( self.effect_cast, false )
    ParticleManager:ReleaseParticleIndex( self.effect_cast )

    -- Stop sound
    local sound_cast = "Hero_Boodseeker.Bloodmist"
    StopSoundOn( sound_cast, self:GetParent() )
end

function modifier_bloodseeker_blood_mist_custom_buff:OnIntervalThink()
    ParticleManager:SetParticleControl(self.effect_cast, 0, self:GetParent():GetOrigin())
end

function modifier_bloodseeker_blood_mist_custom_buff:GetAuraSearchType()
  return bit.bor(DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_CREEP)
end

function modifier_bloodseeker_blood_mist_custom_buff:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_bloodseeker_blood_mist_custom_buff:GetAuraRadius()
  return self:GetAbility():GetLevelSpecialValueFor("radius", (self:GetAbility():GetLevel() - 1))
end

function modifier_bloodseeker_blood_mist_custom_buff:GetModifierAura()
    return "modifier_bloodseeker_blood_mist_custom_buff_aura"
end

function modifier_bloodseeker_blood_mist_custom_buff:GetAuraEntityReject(target)
    if target:GetLevel() > self:GetCaster():GetLevel() then return true end

    return target:IsMagicImmune() -- Do not target magic immune units
end
--
function modifier_bloodseeker_blood_mist_custom_buff_aura:OnCreated()
    if not IsServer() then return end

    self.ability = self:GetAbility()
    self.dmgPct = self.ability:GetSpecialValueFor("max_hp_damage_pct")

    self:StartIntervalThink(0.2)
end

function modifier_bloodseeker_blood_mist_custom_buff_aura:OnIntervalThink()
    local target = self:GetParent()
    if target:IsMagicImmune() then return end

    -- deal %hp dmg separately with no spell amp --
    local dmgHP = (target:GetMaxHealth() * (self.dmgPct/100)) * 0.2
    if IsBossTCOTRPG(target) then
        dmgHP = dmgHP * (self.ability:GetSpecialValueFor("boss_effectiveness")/100)
    end

    local damageHPPct = {
        victim = target,
        attacker = self:GetCaster(),
        damage = dmgHP,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        --ability = self.ability // can't crit
    }

    ApplyDamage(damageHPPct)
    --

    -- deal the flat damage from thirst separately and with spell amp. can crit. --
    local dmg = 0
    local thirstAbility = self:GetCaster():FindAbilityByName("bloodseeker_thirst_custom")
    if thirstAbility ~= nil and thirstAbility:GetLevel() > 0 then
        if self:GetCaster():HasModifier("modifier_bloodseeker_thirst_custom_buff_permanent") then
            dmg = self:GetCaster():FindModifierByName("modifier_bloodseeker_thirst_custom_buff_permanent"):GetStackCount() * self.ability:GetSpecialValueFor("thirst_damage_per_stack")
        end

        local damageFlat = {
            victim = target,
            attacker = self:GetCaster(),
            damage = dmg,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_FORCE_SPELL_AMPLIFICATION,
            ability = self.ability
        }

        ApplyDamage(damageFlat)
    end
    -- end --

    -- Aghs scepter --
    if self:GetCaster():HasScepter() then
        local rupture = self:GetCaster():FindAbilityByName("bloodseeker_rupture_custom")
        if rupture ~= nil and rupture:GetLevel() > 0 then
            local ruptureMaxStacks = rupture:GetSpecialValueFor("max_stacks")
            local ruptureMod = target:FindModifierByNameAndCaster("modifier_bloodseeker_rupture_custom_debuff", self:GetCaster())

            if ruptureMod == nil then
                ruptureMod = target:AddNewModifier(self:GetCaster(), rupture, "modifier_bloodseeker_rupture_custom_debuff", { duration = rupture:GetSpecialValueFor("duration") })
                ruptureMod:SetStackCount(ruptureMaxStacks)
                ruptureMod:ForceRefresh()
            else
                ruptureMod:SetStackCount(ruptureMaxStacks)
                ruptureMod:ForceRefresh()
            end
        end
    end
    --
    
    self:GetCaster():Heal(dmg+dmgHP, self:GetAbility())
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), dmg+dmgHP, nil)
end

function modifier_bloodseeker_blood_mist_custom_buff_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, --GetModifierMoveSpeedBonus_Percentage
    }

    return funcs
end

function modifier_bloodseeker_blood_mist_custom_buff_aura:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("movement_slow")
end
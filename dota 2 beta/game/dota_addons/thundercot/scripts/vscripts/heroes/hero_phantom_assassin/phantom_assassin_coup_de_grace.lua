phantom_assassin_coup_de_grace_custom = class({})
LinkLuaModifier( "modifier_phantom_assassin_coup_de_grace_custom", "heroes/hero_phantom_assassin/phantom_assassin_coup_de_grace.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_coup_de_grace_custom_stacks", "heroes/hero_phantom_assassin/phantom_assassin_coup_de_grace.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_coup_de_grace_custom_activated", "heroes/hero_phantom_assassin/phantom_assassin_coup_de_grace.lua", LUA_MODIFIER_MOTION_NONE )

local BaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return true end,
    IsDebuff = function(self) return false end,
}

modifier_phantom_assassin_coup_de_grace_custom_stacks = class(BaseClass)
modifier_phantom_assassin_coup_de_grace_custom_activated = class(BaseClass)
---
function modifier_phantom_assassin_coup_de_grace_custom_stacks:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Passive Modifier
function phantom_assassin_coup_de_grace_custom:GetIntrinsicModifierName()
    return "modifier_phantom_assassin_coup_de_grace_custom"
end

function phantom_assassin_coup_de_grace_custom:OnSpellStart()
    if not IsServer() then return end

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_coup_de_grace_custom_activated", {
        duration = self:GetSpecialValueFor("active_duration")
    })

    self:UseResources(true,true,true)
end

modifier_phantom_assassin_coup_de_grace_custom = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_phantom_assassin_coup_de_grace_custom:IsHidden()
    -- actual true
    return true
end

function modifier_phantom_assassin_coup_de_grace_custom:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_phantom_assassin_coup_de_grace_custom:OnCreated( kv )
    -- references
    self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
    self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_bonus" )
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
end

function modifier_phantom_assassin_coup_de_grace_custom:OnRefresh( kv )
    -- references
    self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
    self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_bonus" )
end

function modifier_phantom_assassin_coup_de_grace_custom:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_phantom_assassin_coup_de_grace_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    }

    return funcs
end

function modifier_phantom_assassin_coup_de_grace_custom:GetModifierPreAttack_CriticalStrike( params )
    if IsServer() and (not self:GetParent():PassivesDisabled()) then
        local cc = self.crit_chance
        if self.parent:HasTalent("special_bonus_unique_phantom_assassin_2") then
            cc = cc + 7
        end

        if self.parent:HasModifier("modifier_phantom_assassin_coup_de_grace_custom_activated") then
            cc = self:GetAbility():GetSpecialValueFor("active_crit_chance")
        end

        if self:RollChance(cc) then
            self.record = params.record
            if self.parent:HasModifier("modifier_phantom_assassin_coup_de_grace_custom_stacks") then
                return self.crit_bonus + self.parent:FindModifierByName("modifier_phantom_assassin_coup_de_grace_custom_stacks"):GetStackCount()
            else
                return self.crit_bonus
            end
        end
    end
end

function modifier_phantom_assassin_coup_de_grace_custom:GetModifierProcAttack_Feedback( params )
    if IsServer() then
        if self.record then
            self.record = nil
            self:PlayEffects( params.target )

            local modName = "modifier_phantom_assassin_coup_de_grace_custom_stacks"
            if not self.parent:HasModifier(modName) then
                self.parent:AddNewModifier(self.parent, self.ability, modName, {}):SetStackCount(1)
            else
                self.parent:FindModifierByName(modName):IncrementStackCount()
            end
        end
    end
end
--------------------------------------------------------------------------------
-- Helper
function modifier_phantom_assassin_coup_de_grace_custom:RollChance( chance )
    local rand = math.random()
    if rand<chance/100 then
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_phantom_assassin_coup_de_grace_custom:PlayEffects( target )
    -- Load effects
    local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
    local sound_cast = "Hero_PhantomAssassin.CoupDeGrace"

    -- if target:IsMechanical() then
    --  particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf"
    --  sound_cast = "Hero_PhantomAssassin.CoupDeGrace.Mech"
    -- end

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        0,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        target:GetOrigin(), -- unknown
        true -- unknown, true
    )
    ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    EmitSoundOn( sound_cast, target )
end
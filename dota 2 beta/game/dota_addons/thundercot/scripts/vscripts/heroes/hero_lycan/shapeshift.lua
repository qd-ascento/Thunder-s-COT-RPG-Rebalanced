LinkLuaModifier("modifier_lycan_shapeshift_custom", "heroes/hero_lycan/shapeshift.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_shapeshift_custom_buff", "heroes/hero_lycan/shapeshift.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_shapeshift_custom_casting", "heroes/hero_lycan/shapeshift.lua", LUA_MODIFIER_MOTION_NONE)

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

lycan_shapeshift_custom = class(ItemBaseClass)
modifier_lycan_shapeshift_custom = class(lycan_shapeshift_custom)
modifier_lycan_shapeshift_custom_buff = class(ItemBaseClassBuff)
modifier_lycan_shapeshift_custom_casting = class(ItemBaseClass)
-------------
function lycan_shapeshift_custom:GetIntrinsicModifierName()
    return "modifier_lycan_shapeshift_custom"
end

function lycan_shapeshift_custom:OnSpellStart()
    if not IsServer() then return end
--
    local caster = self:GetCaster()
    local ability = self
    local radius = ability:GetSpecialValueFor("radius")
    local duration = ability:GetSpecialValueFor("duration")

    -- set their duration: how?

    if not caster:IsIllusion() then
        local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_POINT_FOLLOW, caster )
        ParticleManager:SetParticleControl( effect_cast, 0, caster:GetAbsOrigin() )
        ParticleManager:ReleaseParticleIndex( effect_cast )

        EmitSoundOn("Hero_Lycan.Shapeshift.Cast", caster)
    end

    Timers:CreateTimer(ability:GetSpecialValueFor("transformation_time"), function()
        caster:AddNewModifier(caster, ability, "modifier_lycan_shapeshift_custom_buff", { duration = duration })
    end)
end

---
function modifier_lycan_shapeshift_custom:OnCreated()
    if not IsServer() then return end

    self:StartIntervalThink(0.5)
end

function modifier_lycan_shapeshift_custom:OnIntervalThink()
    local caster = self:GetParent()

    if not caster:IsAlive() then return end
    
    local ability = self:GetAbility()

    if not GameRules:IsDaytime() then
        -- If it's night time we remove the current shapeshift and apply a new
        -- shapeshift with no duration!
        if caster:HasModifier("modifier_lycan_shapeshift_custom_buff") then
            local mod = caster:FindModifierByNameAndCaster("modifier_lycan_shapeshift_custom_buff", caster)
            if mod == nil then return end
            if mod:GetDuration() > -1 then
                caster:RemoveModifierByName("modifier_lycan_shapeshift_custom_buff")
                caster:AddNewModifier(caster, ability, "modifier_lycan_shapeshift_custom_buff", {})

                if not caster:IsIllusion() then
                    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_POINT_FOLLOW, caster )
                    ParticleManager:SetParticleControl( effect_cast, 0, caster:GetAbsOrigin() )
                    ParticleManager:ReleaseParticleIndex( effect_cast )

                    EmitSoundOn("Hero_Lycan.Shapeshift.Cast", caster)
                end
            end
        else
            caster:AddNewModifier(caster, ability, "modifier_lycan_shapeshift_custom_buff", {})

            if not caster:IsIllusion() then
                local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_POINT_FOLLOW, caster )
                ParticleManager:SetParticleControl( effect_cast, 0, caster:GetAbsOrigin() )
                ParticleManager:ReleaseParticleIndex( effect_cast )

                EmitSoundOn("Hero_Lycan.Shapeshift.Cast", caster)
            end
        end
    else
        -- If it turns into day, we simply take the current shape shift (if there is one)
        -- and sets the duration to the original duration
        if caster:HasModifier("modifier_lycan_shapeshift_custom_buff") then
            local mod = caster:FindModifierByNameAndCaster("modifier_lycan_shapeshift_custom_buff", caster)
            if mod == nil then return end
            if mod:GetDuration() <= -1 then
                mod:SetDuration(self:GetAbility():GetSpecialValueFor("duration"), true)
            end
        end
    end

    if caster:HasScepter() then
        local ability = caster:FindAbilityByName("lycan_wolf_bite_custom")
        if ability:IsHidden() then
            ability:SetLevel(1)
            ability:SetHidden(false)
        end
    end
end
---
function modifier_lycan_shapeshift_custom_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, --GetModifierMoveSpeedBonus_Constant
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION, --GetBonusNightVision
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
        MODIFIER_PROPERTY_MODEL_CHANGE 
    }

    return funcs
end

function modifier_lycan_shapeshift_custom_buff:GetModifierPreAttack_CriticalStrike( params )
    if IsServer() and (not self:GetParent():PassivesDisabled()) then
        local cc = self:GetAbility():GetSpecialValueFor("crit_chance")

        if RollPercentage(cc) then
            self.record = params.record
            return self:GetAbility():GetSpecialValueFor("crit_multiplier")
        end
    end
end

function modifier_lycan_shapeshift_custom_buff:GetModifierProcAttack_Feedback( params )
    if IsServer() then
        if self.record then
            self.record = nil
        end
    end
end

function modifier_lycan_shapeshift_custom_buff:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_lycan_shapeshift_custom_buff:GetBonusNightVision()
    return self:GetAbility():GetSpecialValueFor("bonus_night_vision")
end

function modifier_lycan_shapeshift_custom_buff:GetModifierExtraHealthPercentage()
    return self:GetAbility():GetSpecialValueFor("health_bonus_pct")
end

function modifier_lycan_shapeshift_custom_buff:GetModifierModelChange()
    return "models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl"
end

function modifier_lycan_shapeshift_custom_buff:GetEffectName()
    return "particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf"
end

function modifier_lycan_shapeshift_custom_buff:CheckState()
    local state = {
        [MODIFIER_STATE_UNSLOWABLE] = true
    }

    return state
end
---
function modifier_lycan_shapeshift_custom_casting:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
    }

    return state
end
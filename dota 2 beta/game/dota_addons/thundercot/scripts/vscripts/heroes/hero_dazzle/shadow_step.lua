LinkLuaModifier("modifier_dazzle_shadow_step", "heroes/hero_dazzle/shadow_step.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dazzle_shadow_step_emitter", "heroes/hero_dazzle/shadow_step.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dazzle_shadow_step_emitter_aura", "heroes/hero_dazzle/shadow_step.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dazzle_shadow_wave_autocast", "heroes/hero_dazzle/shadow_step.lua", LUA_MODIFIER_MOTION_NONE)


local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseAura = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return false end,
}

dazzle_shadow_step = class(ItemBaseClass)
modifier_dazzle_shadow_step = class(dazzle_shadow_step)
modifier_dazzle_shadow_step_emitter = class(ItemBaseClass)
modifier_dazzle_shadow_step_emitter_aura = class(ItemBaseAura)

modifier_dazzle_shadow_wave_autocast = class({})
-------------
function modifier_dazzle_shadow_wave_autocast:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_dazzle_shadow_wave_autocast:OnDeath(event)
    local parent = self:GetParent()
    if parent ~= event.unit then return end
    local ability = parent:FindAbilityByName("windrunner_windrun")
    if not ability or ability:GetLevel() < 1 or not ability:GetAutoCastState() then return end
    ability:ToggleAutoCast()
    parent:RemoveModifierByNameAndCaster("modifier_dazzle_shadow_wave_autocast", parent)
end

function modifier_dazzle_shadow_wave_autocast:OnCreated()
    if not IsServer() then return end

    self:StartIntervalThink(0.5)
end

function modifier_dazzle_shadow_wave_autocast:IsHidden()
    return true
end

function modifier_dazzle_shadow_wave_autocast:RemoveOnDeath()
    return false
end

function modifier_dazzle_shadow_wave_autocast:OnIntervalThink()
    if self:GetAbility():GetAutoCastState() and self:GetAbility():IsFullyCastable() and self:GetAbility():IsCooldownReady() then
        local caster = self:GetParent()
        local closest = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil,
            self:GetAbility():GetSpecialValueFor("bounce_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST, false)

        if #closest > 0 then
            self:GetParent():CastAbilityOnTarget(closest[1], self:GetAbility(), 1)
            self:GetAbility():UseResources(true, false, true)
        end
    end
end
-------------
function dazzle_shadow_step:GetIntrinsicModifierName()
    return "modifier_dazzle_shadow_step"
end

function dazzle_shadow_step:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function dazzle_shadow_step:OnSpellStart()
    if not IsServer() then return end
--
    local point = self:GetCursorPosition()
    local caster = self:GetCaster()
    local ability = self
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local interval = ability:GetLevelSpecialValueFor("interval", (ability:GetLevel() - 1))
    local heal = ability:GetLevelSpecialValueFor("hp_heal_pct", (ability:GetLevel() - 1))
    local blinkMaxRange = ability:GetLevelSpecialValueFor("max_range", (ability:GetLevel() - 1))

    -- Teleport them --
    local origin_point = caster:GetAbsOrigin()
    local target_point = caster:GetCursorPosition()
    local difference_vector = target_point - origin_point
    
    if difference_vector:Length2D() > blinkMaxRange then  --Clamp the target point to the BlinkRangeClamp range in the same direction.
        target_point = origin_point + (target_point - origin_point):Normalized() * blinkMaxRange
    end

    ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9_crimson_impact_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster))
    
    caster:SetAbsOrigin(target_point)
    FindClearSpaceForUnit(caster, target_point, false)
    -- --

    -- Particle --
    local vfx = ParticleManager:CreateParticle("particles/dazzle/dazzle_shadow_step.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(vfx, 0, target_point)
    ParticleManager:SetParticleControl(vfx, 1, Vector(radius, radius, radius))
    -- --

    -- Create Placeholder Unit that holds the aura --
    local emitter = CreateUnitByName("outpost_placeholder_unit", target_point, false, caster, caster, caster:GetTeamNumber())
    emitter:AddNoDraw()
    emitter:AddNewModifier(caster, ability, "modifier_dazzle_shadow_step_emitter", { duration = duration, radius = radius, heal = heal, interval = interval })
    -- --

    caster:EmitSound("Hero_Dazzle.BadJuJu.Target")

    Timers:CreateTimer(duration, function()
        ParticleManager:DestroyParticle(vfx, true)
        ParticleManager:ReleaseParticleIndex(vfx)
        emitter:ForceKill(false)
    end)
end
------------
function modifier_dazzle_shadow_step:DeclareFunctions()
    local funcs = {}

    return funcs
end

function modifier_dazzle_shadow_step:OnCreated()
    if not IsServer() then return end
end
----------------
function modifier_dazzle_shadow_step_emitter:OnCreated(params)
    if not IsServer() then return end

    local caster = self:GetCaster()
    local parent = self:GetParent()

    self.radius = params.radius
    self.duration = params.duration
    self.heal = params.heal
    self.interval = params.interval

    -- Start the thinker to drain hp/do damage --
    self:StartIntervalThink(self.interval)
end

function modifier_dazzle_shadow_step_emitter:OnIntervalThink()
    local caster = self:GetCaster()
    local parent = self:GetParent()

    local units = FindUnitsInRadius(caster:GetTeam(), parent:GetAbsOrigin(), nil,
        self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, bit.bor(DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC), DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST, false)

    for _,unit in ipairs(units) do
        local amount = unit:GetMaxHealth() * (self.heal/100)
        unit:SetHealth(unit:GetHealth() + amount)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, amount, nil)
    end
end

function modifier_dazzle_shadow_step_emitter:OnDestroy()
    if not IsServer() then return end

    self:GetParent():ForceKill(false)
end

function modifier_dazzle_shadow_step_emitter:CheckState()
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

function modifier_dazzle_shadow_step_emitter:IsAura()
  return true
end

function modifier_dazzle_shadow_step_emitter:GetAuraSearchType()
  return bit.bor(DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_CREEP)
end

function modifier_dazzle_shadow_step_emitter:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_dazzle_shadow_step_emitter:GetAuraRadius()
  return self.radius
end

function modifier_dazzle_shadow_step_emitter:GetModifierAura()
    return "modifier_dazzle_shadow_step_emitter_aura"
end

function modifier_dazzle_shadow_step_emitter:GetAuraEntityReject(ent) 
    return false
end
--------------
function modifier_dazzle_shadow_step_emitter_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
end

function modifier_dazzle_shadow_step_emitter_aura:GetModifierIncomingDamage_Percentage()
    return self:GetAbility():GetLevelSpecialValueFor("damage_reduction", (self:GetAbility():GetLevel() - 1))
end
LinkLuaModifier("modifier_bloodseeker_thirst_custom", "heroes/hero_bloodseeker/thirst.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_buff_permanent", "heroes/hero_bloodseeker/thirst.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}
local ItemBaseClassBuff = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return true end,
    IsDebuff = function(self) return false end,
}


bloodseeker_thirst_custom = class(ItemBaseClass)
modifier_bloodseeker_thirst_custom = class(bloodseeker_thirst_custom)
modifier_bloodseeker_thirst_custom_buff_permanent = class(ItemBaseClassBuff)
-------------
function modifier_bloodseeker_thirst_custom_buff_permanent:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bloodseeker_thirst_custom_buff_permanent:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT , --GetModifierBaseAttackTimeConstant
    }

    return funcs
end

function modifier_bloodseeker_thirst_custom_buff_permanent:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor("spell_amp_per_kill") * self:GetStackCount()
end

function modifier_bloodseeker_thirst_custom_buff_permanent:GetModifierBaseAttackTimeConstant()
    local decrease = 1.7 - (self:GetAbility():GetSpecialValueFor("bat_decrease_per_kill") * self:GetStackCount())
    local minBat = self:GetAbility():GetSpecialValueFor("min_bat")
    if decrease < minBat then
        decrease = minBat
    end

    return decrease
end
-------------
function bloodseeker_thirst_custom:GetIntrinsicModifierName()
    return "modifier_bloodseeker_thirst_custom"
end


function modifier_bloodseeker_thirst_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH 
    }
    return funcs
end

function modifier_bloodseeker_thirst_custom:OnCreated()
    self.parent = self:GetParent()
end

function modifier_bloodseeker_thirst_custom:OnDeath(event)
    local unit = event.attacker
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local victim = event.unit

    if unit ~= parent then
        return
    end

    local ability = self:GetAbility()

    local buff = unit:FindModifierByNameAndCaster("modifier_bloodseeker_thirst_custom_buff_permanent", unit)
    local stacks = unit:GetModifierStackCount("modifier_bloodseeker_thirst_custom_buff_permanent", unit)
    
    if not buff then
        unit:AddNewModifier(unit, ability, "modifier_bloodseeker_thirst_custom_buff_permanent", {})
    else
        buff:ForceRefresh()
    end

    unit:SetModifierStackCount("modifier_bloodseeker_thirst_custom_buff_permanent", unit, (stacks + 1))

    local heal = victim:GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("heal_per_kill_pct")/100)
    caster:Heal(heal, self:GetAbility())
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal, nil)
    self:PlayEffects(caster)
end

function modifier_bloodseeker_thirst_custom:GetEffectName()
    return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end

function modifier_bloodseeker_thirst_custom:PlayEffects(target)
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf"
    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        0,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )
    ParticleManager:SetParticleControl( effect_cast, 0, target:GetAbsOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end
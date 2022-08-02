LinkLuaModifier("modifier_player_difficulty_buff_heal_on_kill_25", "modifiers/modes/buffs/easy/modifier_player_difficulty_buff_heal_on_kill_25.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return false end,
}

player_difficulty_buff_heal_on_kill_25 = class({
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
})

modifier_player_difficulty_buff_heal_on_kill_25 = class(ItemBaseClass)

function player_difficulty_buff_heal_on_kill_25:GetIntrinsicModifierName()
    return "modifier_player_difficulty_buff_heal_on_kill_25"
end

function modifier_player_difficulty_buff_heal_on_kill_25:GetTexture() return "healonkill" end
-------------
function modifier_player_difficulty_buff_heal_on_kill_25:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,  
    }

    return funcs
end

function modifier_player_difficulty_buff_heal_on_kill_25:OnDeath(event)
    if event.attacker ~= self:GetParent() then return end

    local attacker = event.attacker
    local victim = event.unit

    if attacker == victim then return end

    local heal = victim:GetMaxHealth() * 0.25

    attacker:Heal(heal, self:GetAbility())

    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, attacker, heal, nil)

    self:PlayEffect(attacker)
end

function modifier_player_difficulty_buff_heal_on_kill_25:PlayEffect(target)
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
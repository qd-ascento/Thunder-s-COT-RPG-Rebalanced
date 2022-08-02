LinkLuaModifier("modifier_player_difficulty_boon_self_death_explosion_60", "modifiers/modes/buffs/impossible/modifier_player_difficulty_boon_self_death_explosion_60.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return true end,
}

player_difficulty_boon_self_death_explosion_60 = class({
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
})

modifier_player_difficulty_boon_self_death_explosion_60 = class(ItemBaseClass)

function player_difficulty_boon_self_death_explosion_60:GetIntrinsicModifierName()
    return "modifier_player_difficulty_boon_self_death_explosion_60"
end

function modifier_player_difficulty_boon_self_death_explosion_60:GetTexture() return "bomb" end
-------------
function modifier_player_difficulty_boon_self_death_explosion_60:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,  
    }

    return funcs
end

function modifier_player_difficulty_boon_self_death_explosion_60:OnDeath(event)
    if event.unit ~= self:GetParent() then return end

    local attacker = event.attacker
    local unit = event.unit

    self:PlayEffect(unit)

    local victims = FindUnitsInRadius(unit:GetTeam(), unit:GetAbsOrigin(), nil,
        400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, bit.bor(DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC), DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST, false)

    for _,victim in ipairs(victims) do
        if 
            victim:IsAlive() and 
            not victim:IsMagicImmune()
        then
            local dmg = unit:GetMaxHealth() * 0.60

            ApplyDamage({
                victim = victim,
                attacker = attacker,
                damage = dmg,
                damage_type = DAMAGE_TYPE_MAGICAL,
                damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            })

            SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, victim, dmg, nil)
        end
    end

    EmitSoundOn("Hero_Techies.Suicide", event.unit)
end

function modifier_player_difficulty_boon_self_death_explosion_60:PlayEffect(target)
    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_blast_off.vpcf", PATTACH_POINT_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        0,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )
    ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end
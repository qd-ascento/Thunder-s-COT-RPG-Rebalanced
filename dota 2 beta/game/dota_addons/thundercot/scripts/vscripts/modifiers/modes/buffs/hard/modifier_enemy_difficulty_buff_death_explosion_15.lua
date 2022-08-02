LinkLuaModifier("modifier_enemy_difficulty_buff_death_explosion_15", "modifiers/modes/buffs/hard/modifier_enemy_difficulty_buff_death_explosion_15.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return true end,
}

enemy_difficulty_buff_death_explosion_15 = class({
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
})

modifier_enemy_difficulty_buff_death_explosion_15 = class(ItemBaseClass)

function enemy_difficulty_buff_death_explosion_15:GetIntrinsicModifierName()
    return "modifier_enemy_difficulty_buff_death_explosion_15"
end

function modifier_enemy_difficulty_buff_death_explosion_15:GetTexture() return "skull" end
-------------
function modifier_enemy_difficulty_buff_death_explosion_15:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,  
    }

    return funcs
end

function modifier_enemy_difficulty_buff_death_explosion_15:OnDeath(event)
    if event.unit ~= self:GetParent() then return end

    local attacker = event.attacker
    local unit = event.unit

    self:PlayEffect(unit)

    local victims = FindUnitsInRadius(unit:GetTeam(), unit:GetAbsOrigin(), nil,
        400, DOTA_UNIT_TARGET_TEAM_ENEMY, bit.bor(DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC), DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST, false)

    for _,victim in ipairs(victims) do
        if 
            victim:IsAlive() and 
            not victim:IsMagicImmune()
        then
            local dmg = unit:GetMaxHealth() * 0.1

            ApplyDamage({
                victim = victim,
                attacker = event.unit,
                damage = dmg,
                damage_type = DAMAGE_TYPE_MAGICAL,
                damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                ability = self:GetAbility(),
            })

            SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, victim, dmg, nil)
        end
    end
end

function modifier_enemy_difficulty_buff_death_explosion_15:PlayEffect(target)
    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_clean_low.vpcf", PATTACH_POINT_FOLLOW, target )
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
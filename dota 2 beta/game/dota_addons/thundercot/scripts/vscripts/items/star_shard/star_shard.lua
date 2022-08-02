LinkLuaModifier("modifier_item_star_shard", "items/star_shard/star_shard.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_star_shard_active", "items/star_shard/star_shard.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_star_shard_debuff", "items/star_shard/star_shard.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassActive = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return false end,
}

local ItemDebuff = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return true end,
}

item_star_shard = class(ItemBaseClass)
item_star_shard_2 = item_star_shard
item_star_shard_3 = item_star_shard
item_star_shard_4 = item_star_shard
item_star_shard_5 = item_star_shard
item_star_shard_6 = item_star_shard
modifier_item_star_shard = class(ItemBaseClass)
modifier_item_star_shard_active = class(ItemBaseClassActive)
modifier_item_star_shard_debuff = class(ItemDebuff)
-------------
function item_star_shard:GetIntrinsicModifierName()
    return "modifier_item_star_shard"
end

function item_star_shard:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()

    if not caster:IsRangedAttacker() then DisplayError(caster:GetPlayerID(), "Only Works For Ranged Heroes.") return end

    local ability = self
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    
    caster:AddNewModifier(caster, ability, "modifier_item_star_shard_active", { duration = duration })
end
---
function modifier_item_star_shard_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS , --GetModifierMagicalResistanceBonus
    }
    return funcs
end

function modifier_item_star_shard_debuff:GetModifierMagicalResistanceBonus()
    return self:GetAbility():GetSpecialValueFor("star_magic_res")
end

function modifier_item_star_shard:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, --GetModifierBonusStats_Intellect
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS, --GetModifierBonusStats_Agility
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, --GetModifierAttackSpeedBonus_Constant
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, --GetModifierMoveSpeedBonus_Percentage
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK,
        --MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE 
    }

    return funcs
end

function modifier_item_star_shard:GetModifierTotalDamageOutgoing_Percentage(params)
    if IsServer() then
        if params.attacker ~= self:GetParent() then return end
        if params.attacker == params.target then return end
        if params.damage_type ~= DAMAGE_TYPE_MAGICAL then return end


        local bonusDamage = (params.original_damage + (self:GetParent():GetBaseIntellect() * (self:GetAbility():GetSpecialValueFor("agi_to_magic_pct")/100)))
        local total = bonusDamage / params.original_damage
        local damagePercent = params.original_damage*total
 
        SendOverheadEventMessage(
            nil,
            OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
            params.target,
            bonusDamage,
            nil
        )

        return damagePercent
    end
end

function modifier_item_star_shard:OnAttack(event)
    if not IsServer() then return end

    if event.attacker ~= self:GetParent() then return end

    local target = event.target
    local attacker = event.attacker
    local ability = self:GetAbility()
    --if not attacker:IsRangedAttacker() then return end
    if not RollPercentage(ability:GetSpecialValueFor("star_chance")) then return end
    if attacker:HasModifier("modifier_item_star_shard_active") then return end

    local projName = "particles/units/heroes/hero_wisp/wisp_base_attack.vpcf"
    local projSpeed = attacker:GetProjectileSpeed()

    local info = {
        Target = target,
        Source = attacker,
        Ability = ability,  
        EffectName = projName,
        iMoveSpeed = projSpeed,
        vSourceLoc = attacker:GetAbsOrigin(),                -- Optional (HOW)
        bDrawsOnMinimap = false,                          -- Optional
        bDodgeable = false,                                -- Optional
        bIsAttack = true,                                -- Optional
        bVisibleToEnemies = true,                         -- Optional
        bReplaceExisting = false,                         -- Optional
        bProvidesVision = false,                           -- Optional
        ExtraData = {
            source = 1
        }
    }

    Timers:CreateTimer(0.15, function()
        ProjectileManager:CreateTrackingProjectile(info)
    end)
end

function modifier_item_star_shard:GetModifierBonusStats_Intellect()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_item_star_shard:GetModifierBonusStats_Agility()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_star_shard:GetModifierSpellAmplify_Percentage()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_item_star_shard:GetModifierAttackSpeedBonus_Constant()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_star_shard:GetModifierMoveSpeedBonus_Percentage()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("movement_speed_percent_bonus")
end

function modifier_item_star_shard:GetModifierConstantManaRegen()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("mana_regen")
end
--

function modifier_item_star_shard:OnCreated()
    if not IsServer() then return end

    --self:StartIntervalThink(0.1)
end

function modifier_item_star_shard:OnIntervalThink()
    local caster = self:GetCaster()

    if caster:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_AGILITY and caster:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_INTELLECT then
        caster:DropItemAtPositionImmediate(self:GetAbility(), caster:GetAbsOrigin())
        DisplayError(caster:GetPlayerID(), "Only Agility and Intellect heroes can use this item.")
    end

    self:StartIntervalThink(-1)
end
---
function modifier_item_star_shard_active:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK 
        
    }

    return funcs
end

function modifier_item_star_shard_active:OnAttack(event)
    if not IsServer() then return end

    if event.attacker ~= self:GetParent() then return end

    local target = event.target
    local attacker = event.attacker
    local ability = self:GetAbility()
    if not attacker:IsRangedAttacker() then return end

    local projName = "particles/units/heroes/hero_wisp/wisp_base_attack.vpcf"
    local projSpeed = attacker:GetProjectileSpeed()

    local info = {
        Target = target,
        Source = attacker,
        Ability = ability,  
        EffectName = projName,
        iMoveSpeed = projSpeed,
        vSourceLoc = attacker:GetAbsOrigin(),                -- Optional (HOW)
        bDrawsOnMinimap = false,                          -- Optional
        bDodgeable = false,                                -- Optional
        bIsAttack = true,                                -- Optional
        bVisibleToEnemies = true,                         -- Optional
        bReplaceExisting = false,                         -- Optional
        bProvidesVision = false,                           -- Optional
        ExtraData = {
            source = 1
        }
    }

    Timers:CreateTimer(0.15, function()
        ProjectileManager:CreateTrackingProjectile(info)
    end)
end

function item_star_shard:OnProjectileHit(target, location)
    if not IsServer() then return end

    if not target then return end
    if not target:IsAlive() then return end
    if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end

    local damage = self:GetCaster():GetBaseIntellect() * (self:GetSpecialValueFor("active_agi_as_damage_pct")/100)

    local victims = FindUnitsInRadius(self:GetCaster():GetTeam(), target:GetAbsOrigin(), nil,
        self:GetSpecialValueFor("star_aoe"), DOTA_UNIT_TARGET_TEAM_ENEMY, bit.bor(DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC), DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST, false)

    for _,victim in ipairs(victims) do
        if not victim:IsAlive() then break end

        ApplyDamage({
            victim = victim, 
            attacker = self:GetCaster(), 
            damage = damage, 
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        })

        SendOverheadEventMessage(
            nil,
            OVERHEAD_ALERT_DAMAGE,
            victim,
            damage,
            nil
        )

        victim:AddNewModifier(self:GetCaster(), self, "modifier_item_star_shard_debuff", { duration = self:GetSpecialValueFor("star_magic_res_duration") })
    end

    -- vfx --
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf"
    local sound_cast = "Hero_Wisp.Spirits.Target"

    -- Get Data

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
    ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOn( sound_cast, target )
end

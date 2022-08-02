LinkLuaModifier("modifier_bloodletting_blade", "items/bloodletting_blade/item_bloodletting_blade.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}


item_bloodletting_blade = class(ItemBaseClass)
item_bloodletting_blade_2 = item_bloodletting_blade
item_bloodletting_blade_3 = item_bloodletting_blade
item_bloodletting_blade_4 = item_bloodletting_blade
item_bloodletting_blade_5 = item_bloodletting_blade
modifier_bloodletting_blade = class(item_bloodletting_blade)
-------------
function item_bloodletting_blade:GetIntrinsicModifierName()
    return "modifier_bloodletting_blade"
end

function item_bloodletting_blade:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
------------
function modifier_bloodletting_blade:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS, --GetModifierHealthBonus
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, --GetModifierConstantManaRegen
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, --GetModifierPreAttack_BonusDamage
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, --GetModifierConstantHealthRegen
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK, --GetModifierPhysical_ConstantBlock
        MODIFIER_EVENT_ON_TAKEDAMAGE 
    }

    return funcs
end

function modifier_bloodletting_blade:OnTakeDamage(event)
    if event.attacker ~= self:GetParent() then return end
    if event.attacker == event.unit then return end

    local attacker = event.attacker
    local ability = self:GetAbility()

    local allies = FindUnitsInRadius(attacker:GetTeam(), attacker:GetAbsOrigin(), nil,
        ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST, false)

    local heal = event.damage * (ability:GetSpecialValueFor("damage_to_healing_pct")/100)

    for _,ally in ipairs(allies) do
        if not ally:IsAlive() then break end

        ally:Heal(heal, ability)

        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal, nil)
        self:PlayEffects(ally)
    end
end

function modifier_bloodletting_blade:PlayEffects(target)
    -- Get Resources
    local particle_cast = "particles/bloodletting_blade/spectre_arcana_v2_dispersion.vpcf"

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
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        1,
        self:GetParent(),
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )
    -- ParticleManager:SetParticleControl( effect_cast, 1, vControlVector )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end
--------------

function modifier_bloodletting_blade:GetModifierHealthBonus()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_bloodletting_blade:GetModifierConstantManaRegen()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end

function modifier_bloodletting_blade:GetModifierPreAttack_BonusDamage()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_bloodletting_blade:GetModifierConstantHealthRegen()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_bloodletting_blade:GetModifierPhysical_ConstantBlock()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self:GetAbility():GetSpecialValueFor("block_damage")
end

LinkLuaModifier("modifier_furion_living_roots_custom", "heroes/hero_furion/furion_living_roots.lua", LUA_MODIFIER_MOTION_NONE) --- PETH WEFY INPARFANT
LinkLuaModifier("modifier_furion_living_roots_custom_debuff", "heroes/hero_furion/furion_living_roots.lua", LUA_MODIFIER_MOTION_NONE) --- PETH WEFY INPARFANT

local AbilityClass = {
    IsPurgable = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
}

local AbilityClassDebuff = {
    IsPurgable = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsDebuff = function(self) return true end,
}

furion_living_roots_custom = class(AbilityClass)
modifier_furion_living_roots_custom_debuff = class(AbilityClassDebuff)

function furion_living_roots_custom:GetIntrinsicModifierName()
  return "modifier_furion_living_roots_custom"
end

function furion_living_roots_custom:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function furion_living_roots_custom:OnSpellStart()
    if not IsServer() then return end
--
    local point = self:GetCursorPosition()
    local duration = self:GetSpecialValueFor("duration")
    local radius = self:GetSpecialValueFor("radius")
    local caster = self:GetCaster()
    local ability = self

    caster:EmitSound("Hero_Treant.NaturesGrasp.Cast")

    local units = FindUnitsInRadius(caster:GetTeam(), point, nil,
        radius, DOTA_UNIT_TARGET_TEAM_ENEMY, bit.bor(DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_BASIC), DOTA_UNIT_TARGET_FLAG_NO_INVIS,
        FIND_CLOSEST, false)

    if #units > 0 then
        for _,unit in ipairs(units) do
            unit:AddNewModifier(caster, ability, "modifier_furion_living_roots_custom_debuff", { duration = duration })
            unit:EmitSound("Hero_Treant.NaturesGrasp.Spawn")
        end
    end
end
---------------------
function modifier_furion_living_roots_custom_debuff:OnCreated()
    if not IsServer() then return end

    local victim = self:GetParent()

    victim:Stop() -- Stop all channels

    local interval = self:GetAbility():GetLevelSpecialValueFor("damage_interval", (self:GetAbility():GetLevel() - 1))

    self:StartIntervalThink(interval)
end

function modifier_furion_living_roots_custom_debuff:OnIntervalThink()
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()

    if not parent:IsAlive() or parent:GetHealth() < 1 or not ability or ability:IsNull() then
        self:StartIntervalThink(-1)
        return
    end

    local dot = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))

    local damage = {
        victim = parent,
        attacker = caster,
        damage = dot,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability
    }

    ApplyDamage(damage)
end

function modifier_furion_living_roots_custom_debuff:CheckState()
    local states = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true
    }

    return states
end

function modifier_furion_living_roots_custom_debuff:GetEffectName()
    return "particles/units/heroes/hero_treant/treant_bramble_root.vpcf"
end
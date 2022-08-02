LinkLuaModifier("modifier_spectre_dispersion_custom", "spectre_dispersion_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spectre_dispersion_custom_absorb_state", "spectre_dispersion_custom.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassAbsorb = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return false end,
}

spectre_dispersion_custom = class(ItemBaseClass)
modifier_spectre_dispersion_custom = class(spectre_dispersion_custom)
modifier_spectre_dispersion_custom_absorb_state = class(ItemBaseClassAbsorb)
-------------
function spectre_dispersion_custom:GetIntrinsicModifierName()
    return "modifier_spectre_dispersion_custom"
end

function spectre_dispersion_custom:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function spectre_dispersion_custom:OnSpellStart()
    if not IsServer() then return end
--
    local caster = self:GetCaster()
    local ability = self
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    
    caster:AddNewModifier(caster, ability, "modifier_spectre_dispersion_custom_absorb_state", { duration = duration })
end
------------
function modifier_spectre_dispersion_custom_absorb_state:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE 
    }

    return funcs
end

function modifier_spectre_dispersion_custom_absorb_state:OnTakeDamage(event)
    if not IsServer() then return end

    if event.unit ~= self:GetParent() then
        return
    end

    local ability = self:GetAbility()
    local attacker = event.attacker
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local pctReturned = ability:GetLevelSpecialValueFor("return_pct", (ability:GetLevel() - 1))

    -- only add to absorb damage if enemy is close enough to spec

    if (attacker:GetAbsOrigin() - event.unit:GetAbsOrigin()):Length2D() > radius then
        return
    end

    -- The damage is before reductions, so it returns full amount
    self.absorbAmount = self.absorbAmount + event.damage
end

function modifier_spectre_dispersion_custom_absorb_state:OnCreated(props)
    if not IsServer() then return end

    self.absorbAmount = 0

    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()

    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))
    local baseDamage = ability:GetLevelSpecialValueFor("base_damage", (ability:GetLevel() - 1))

    local healPct = ability:GetLevelSpecialValueFor("heal_pct", (ability:GetLevel() - 1))

    Timers:CreateTimer(props.duration, function()
        local victims = FindUnitsInRadius(caster:GetTeam(), parent:GetAbsOrigin(), nil,
            radius, DOTA_UNIT_TARGET_TEAM_ENEMY, bit.bor(DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC), DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST, false)

        for _,victim in ipairs(victims) do
            if victim:IsMagicImmune() then break end

            ApplyDamage({
                victim = victim, 
                attacker = caster, 
                damage = baseDamage + self.absorbAmount, 
                damage_type = DAMAGE_TYPE_MAGICAL,
                damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            })

            local healAmount = ((baseDamage + self.absorbAmount) * (healPct/100))
            caster:Heal(healAmount, nil)
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, healAmount, nil)
        end
    end)
end
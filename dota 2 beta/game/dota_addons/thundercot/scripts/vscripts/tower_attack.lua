LinkLuaModifier("tower_attack_modifier", "tower_attack.lua", LUA_MODIFIER_MOTION_NONE)

local BaseTowerAttack = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
}

tower_attack = class({})
tower_attack_modifier = class(BaseTowerAttack)

function tower_attack:GetIntrinsicModifierName()
    return "tower_attack_modifier"
end

function tower_attack_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function tower_attack_modifier:GetModifierAttackSpeedBonus_Constant()
    return 100
end

function tower_attack_modifier:OnAttackLanded(event)
    if not IsServer() then return end

    local parent = self:GetParent()
    local target = event.target
    local attacker = event.attacker

    if (attacker ~= parent) or (not target) or (target:IsNull()) then
        return
    end

    if target:GetHealth() <= 1 then return end

    ApplyDamage({
        victim = target, 
        attacker = attacker, 
        damage = (target:GetMaxHealth() * 0.09), 
        damage_type = DAMAGE_TYPE_PURE
    })
end

function tower_attack_modifier:CheckState()
    local states = {
        [MODIFIER_STATE_CANNOT_MISS] = true
    }

    return states
end
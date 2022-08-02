LinkLuaModifier("modifier_padla_damage", "heroes/hero_padla/damage.lua", LUA_MODIFIER_MOTION_NONE)

modifier_padla_damage = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

padla_damage = modifier_padla_damage

function modifier_padla_damage:GetTexture() return "padla/damage" end
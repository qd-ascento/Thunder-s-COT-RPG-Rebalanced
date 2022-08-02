LinkLuaModifier("modifier_padla_gavno", "heroes/hero_padla/gavno.lua", LUA_MODIFIER_MOTION_NONE)

modifier_padla_gavno = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

padla_gavno = modifier_padla_gavno

function modifier_padla_gavno:GetTexture() return "padla/gavno" end
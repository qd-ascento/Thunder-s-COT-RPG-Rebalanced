LinkLuaModifier("modifier_padla_zoloto", "heroes/hero_padla/zoloto.lua", LUA_MODIFIER_MOTION_NONE)

modifier_padla_zoloto = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
})

padla_zoloto = modifier_padla_zoloto

function modifier_padla_zoloto:GetTexture() return "padla/zoloto" end
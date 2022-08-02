gun_joe_calibrated_shot = gun_joe_calibrated_shot or class({})
ability = gun_joe_calibrated_shot

LinkLuaModifier( "modifier_gun_joe_calibrated_shot_buff", "heroes/hero_sniper/modifiers/modifier_gun_joe_calibrated_shot_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gun_joe_calibrated_shot_stun", "heroes/hero_sniper/modifiers/modifier_gun_joe_calibrated_shot_stun", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gun_joe_calibrated_shot_autocast", "heroes/hero_sniper/modifiers/modifier_gun_joe_calibrated_shot_autocast", LUA_MODIFIER_MOTION_NONE )

local talent_name = "gun_joe_special_bonus_calibrated"

function ability:GetIntrinsicModifierName()
    return "modifier_gun_joe_calibrated_shot_autocast"
end

function ability:GetCooldown( nLevel )
	if not self or self:IsNull() then return 0 end

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then return 0 end

	local cd = self:GetSpecialValueFor("cooldown")

	if caster:GetTalentSpecialValueFor(talent_name) ~= nil then
		local cd = self:GetSpecialValueFor("cooldown") + caster:GetTalentSpecialValueFor(talent_name)
	end

	return cd
end

function ability:GetCastRange()
	if not self or self:IsNull() then return end

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then return end

	local range = caster:Script_GetAttackRange()

	if not IsServer() or (IsServer() and not self:GetAutoCastState()) then
		range = range + self:GetSpecialValueFor("bonus_attack_range")
	end

	return range
end

function ability:Start( target )
	if not self or self:IsNull() then return end

	if not target or target:IsNull() then return end

	local caster = self:GetCaster()
	
	if not caster or caster:IsNull() then return end

	local projectileSpeed 	= self:GetSpecialValueFor("projectile_speed")

	caster:EmitSound("Ability.Assassinate")

	local particle_info = {
		Target 				= target,
		Source 				= caster,
		Ability 			= self,
		EffectName 			= "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf",
		bDodgeable 			= true,
		bProvidesVision 	= false,
		iMoveSpeed 			= projectileSpeed,
		iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}

	ProjectileManager:CreateTrackingProjectile( particle_info )	
end


function ability:OnProjectileHit(hTarget, vLocation)
	if not IsServer() then return end
	if not self or self:IsNull() then return end
	if not hTarget or hTarget:IsNull() then return end

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then return end

	local mod = caster:AddNewModifier(caster, self, "modifier_gun_joe_calibrated_shot_buff", { duration = 1 })

	local fakeAttack = false
	local canMiss = false

	--caster:PerformAttack(hTarget, true, true, true, true, false, fakeAttack, canMiss)
	ApplyDamage({
		victim = hTarget,
		attacker = caster,
		damage = caster:GetAverageTrueAttackDamage(caster),
		damage_type = self:GetAbilityDamageType(),
		ability = self
	})

	if mod then
		mod:Destroy()
	end

	if not hTarget or hTarget:IsNull() then return end

	hTarget:EmitSound("Hero_Sniper.AssassinateDamage")

	if not hTarget:IsAlive() then return end

	local stunDuration = self:GetSpecialValueFor("stun_duration")

	hTarget:AddNewModifier(caster, self, "modifier_gun_joe_calibrated_shot_stun", { duration = stunDuration})
end

function ability:OnSpellStart( keys )
	if not IsServer() then return end

	self:Start( self:GetCursorTarget(), false)
end

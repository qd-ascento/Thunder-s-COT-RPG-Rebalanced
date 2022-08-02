function Rot(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("rot_damage", ability:GetLevel() - 1) * ability:GetLevelSpecialValueFor("rot_tick", ability:GetLevel() - 1)
	local radius = ability:GetAbilitySpecial("rot_radius")
	if caster:HasScepter() then
		radius = ability:GetAbilitySpecial("rot_radius_scepter")
		damage = ability:GetLevelSpecialValueFor("rot_damage_scepter", ability:GetLevel() - 1) * ability:GetLevelSpecialValueFor("rot_tick", ability:GetLevel() - 1)
		damage = damage + (caster:GetStrength() * (ability:GetSpecialValueFor("damage_str")/100))
	end
	ApplyDamage({attacker = caster, victim = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})
	for _,v in ipairs(FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)) do
		ApplyDamage({attacker = caster, victim = v, damage = damage, damage_type = ability:GetAbilityDamageType(), ability = ability})
		ability:ApplyDataDrivenModifier(caster, v, "modifier_pudge_rot_custom_slow", {})
		if caster:HasScepter() then
			ability:ApplyDataDrivenModifier(caster, v, "modifier_pudge_rot_custom_degen", {})
		end
	end
end

function CreateParticles(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetAbilitySpecial("rot_radius")
	if caster:HasScepter() then
		radius = ability:GetAbilitySpecial("rot_radius_scepter")
	end
	ability.rotPfx = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(ability.rotPfx, 1, Vector(radius,0,0) )
end

function StopRot(keys)
	local caster = keys.caster
	local ability = keys.ability
	if ability.rotPfx then
		ParticleManager:DestroyParticle(ability.rotPfx, false)
		ability.rotPfx = nil
	end
	caster:StopSound("Hero_Pudge.Rot")
end
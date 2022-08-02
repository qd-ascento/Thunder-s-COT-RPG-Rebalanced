function CheckAbility(keys)
	local caster = keys.caster
	local ability = keys.ability
	if ability:IsCooldownReady() and IsServer() then
		local stats_per_cycle = ability:GetLevelSpecialValueFor("stats_per_cycle", ability:GetLevel() - 1)
		local stats_per_cycle_from_stats_pct = ability:GetSpecialValueFor("stats_per_cycle_from_stats_pct")

		local bonusStr = stats_per_cycle + (caster:GetBaseStrength() * (stats_per_cycle_from_stats_pct/100))
		local bonusAgi = stats_per_cycle + (caster:GetBaseAgility() * (stats_per_cycle_from_stats_pct/100))
		local bonusInt = stats_per_cycle + (caster:GetBaseIntellect() * (stats_per_cycle_from_stats_pct/100))

		local preTotalStr = caster:GetStrength() + bonusStr
		local preTotalAgi = caster:GetAgility() + bonusAgi
		local preTotalInt = caster:GetIntellect() + bonusInt
        
        if preTotalStr > 10000000 or preTotalAgi > 10000000 or preTotalInt > 10000000 then 
        	ability:SetActivated(false) 
        	DisplayError(caster:GetPlayerID(), "Limit Reached") 
        	caster:FindModifierByNameAndCaster("modifier_stargazer_cosmic_countdown", caster):StartIntervalThink(-1)
        	return false 
        end

		caster:ModifyStrength(bonusStr)
		caster:ModifyAgility(bonusAgi)
		caster:ModifyIntellect(bonusInt)
		
		ability:StartCooldown(ability:GetEffectiveCooldown(ability:GetLevel()-1))
		caster:EmitSound("Arena.Hero_Stargazer.CosmicCountdown.Cast")
		ParticleManager:CreateParticle("particles/arena/units/heroes/hero_stargazer/cosmic_countdown.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	end
end
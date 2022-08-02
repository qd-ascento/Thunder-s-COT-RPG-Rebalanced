gun_joe_explosive = gun_joe_explosive or class({})
ability = gun_joe_explosive

LinkLuaModifier( "modifier_gun_joe_explosive", 'heroes/hero_sniper/modifiers/modifier_gun_joe_explosive', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ability:OnSpellStart( keys )
	if not self or self:IsNull() then return end

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then return end

	caster:AddNewModifier(caster, self, "modifier_gun_joe_explosive", { duration = self:GetSpecialValueFor("duration") } ) 

	if not caster:HasShardUpgrade() then
		local stack_count = self:GetSpecialValueFor("stack_count") + caster:GetTalentSpecialValueFor("gun_joe_special_bonus_explosive_bullets_stack")
	end

	if caster:HasShardUpgrade() then
		local stack_count = self:GetSpecialValueFor("shard_stack_count") + caster:GetTalentSpecialValueFor("gun_joe_special_bonus_explosive_bullets_stack")
	end

	

	caster:SetModifierStackCount("modifier_gun_joe_explosive", caster, stack_count )
end

function ability:GetCooldown( nLevel )
	if not self or self:IsNull() then return 0 end
	
	local caster = self:GetCaster()

	if not caster or caster:IsNull() then return 0 end

	if not caster:HasModifier("modifier_item_aghanims_shard") then 
		return self:GetSpecialValueFor("cooldown") --+ caster:GetTalentSpecialValueFor("gun_joe_special_bonus_explosive_bullets_cd")
	end

	if caster:HasModifier("modifier_item_aghanims_shard") then 
		return self:GetSpecialValueFor("shard_cooldown") --+ caster:GetTalentSpecialValueFor("gun_joe_special_bonus_explosive_bullets_cd")
	end
end

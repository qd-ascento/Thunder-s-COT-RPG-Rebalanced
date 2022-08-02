modifier_ogre_magi_multicast_custom = class({})
modifier_ogre_magi_multicast_custom.singles = {
	["ogre_magi_fireblast_lua"] = true,
	["ogre_magi_unrefined_fireblast_lua"] = true,
	["ogre_magi_fireblast"] = true,
	["ogre_magi_unrefined_fireblast"] = true,
}

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_multicast_custom:IsHidden()
	return false
end

function modifier_ogre_magi_multicast_custom:IsDebuff()
	return false
end

function modifier_ogre_magi_multicast_custom:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ogre_magi_multicast_custom:OnCreated( kv )
	-- references
	self.chance_2 = self:GetAbility():GetSpecialValueFor( "multicast_2_times" ) * 100
	self.chance_3 = self:GetAbility():GetSpecialValueFor( "multicast_3_times" ) * 100
	self.chance_4 = self:GetAbility():GetSpecialValueFor( "multicast_4_times" ) * 100
	self.chance_5 = self:GetAbility():GetSpecialValueFor( "multicast_5_times" ) * 100

	self.buffer_range = 300
end

function modifier_ogre_magi_multicast_custom:OnRefresh( kv )
	-- references
	self.chance_2 = self:GetAbility():GetSpecialValueFor( "multicast_2_times" ) * 100
	self.chance_3 = self:GetAbility():GetSpecialValueFor( "multicast_3_times" ) * 100
	self.chance_4 = self:GetAbility():GetSpecialValueFor( "multicast_4_times" ) * 100
	self.chance_4 = self:GetAbility():GetSpecialValueFor( "multicast_5_times" ) * 100
end

function modifier_ogre_magi_multicast_custom:OnRemoved()
end

function modifier_ogre_magi_multicast_custom:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ogre_magi_multicast_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_ogre_magi_multicast_custom:OnAbilityFullyCast( params )
	if params.unit~=self:GetCaster() then return end
	if params.ability==self:GetAbility() then return end

	-- cancel if break
	if self:GetCaster():PassivesDisabled() then return end

	-- only spells that have target
	if not params.target then return end

	-- if the spell can do both target and point, it should not trigger
	if bit.band( params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_POINT ) ~= 0 then return end
	if bit.band( params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET ) ~= 0 then return end

	-- roll multicasts
	local casts = 1
	if RandomInt( 0,100 ) < self.chance_2 then casts = 2 end
	if RandomInt( 0,100 ) < self.chance_3 then casts = 3 end
	if RandomInt( 0,100 ) < self.chance_4 then casts = 4 end
	if RandomInt( 0,100 ) < self.chance_5 then casts = 5 end

	-- check delay
	local delay = params.ability:GetSpecialValueFor( "multicast_delay" ) or 0

	-- only for fireblast multicast to single target
	local single = self.singles[params.ability:GetAbilityName()] or false

	-- multicast
	self:GetCaster():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_ogre_magi_multicast_custom_proc", -- modifier name
		{
			ability = params.ability:entindex(),
			target = params.target:entindex(),
			multicast = casts,
			delay = delay,
			single = single,
		} -- kv
	)
end


modifier_ogre_magi_multicast_custom_proc = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_multicast_custom_proc:IsHidden()
	return false
end

function modifier_ogre_magi_multicast_custom_proc:IsDebuff()
	return false
end

function modifier_ogre_magi_multicast_custom_proc:IsStunDebuff()
	return false
end

function modifier_ogre_magi_multicast_custom_proc:IsPurgable()
	return true
end

function modifier_ogre_magi_multicast_custom_proc:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ogre_magi_multicast_custom_proc:OnCreated( kv )
	if not IsServer() then return end
	-- load data
	self.caster = self:GetParent()
	self.ability = EntIndexToHScript( kv.ability )
	self.target = EntIndexToHScript( kv.target )
	self.multicast = kv.multicast
	self.delay = kv.delay
	self.single = kv.single==1
	self.buffer_range = 300

	-- set stack count
	self:SetStackCount( self.multicast )

	-- init multicast
	self.casts = 0
	if self.multicast==1 then
		-- no multicast if just 1
		self:Destroy()
		return
	end

	-- keep a table of targeted units
	self.targets = {}
	self.targets[self.target] = true

	-- get cast range
	self.radius = self.ability:GetCastRange( self.target:GetOrigin(), self.target ) + self.buffer_range

	-- get unit filters
	-- only target the same team as original target, even if the ability can cast on both team
	self.target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	if self.target:GetTeamNumber()~=self.caster:GetTeamNumber() then
		self.target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	end

	-- if custom, findunitsinradius won't work
	self.target_type = self.ability:GetAbilityTargetType()
	if self.target_type==DOTA_UNIT_TARGET_CUSTOM then
		self.target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	end

	-- only check for magic immunity piercing abilities
	self.target_flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
	if bit.band( self.ability:GetAbilityTargetFlags(), DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ) ~= 0 then
		self.target_flags = self.target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	
	-- play effects
	self:PlayEffects( self.casts )

	-- Start interval
	self:StartIntervalThink( self.delay )
end

function modifier_ogre_magi_multicast_custom_proc:OnRefresh( kv )
	
end

function modifier_ogre_magi_multicast_custom_proc:OnRemoved()
end

function modifier_ogre_magi_multicast_custom_proc:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ogre_magi_multicast_custom_proc:OnIntervalThink()
	local current_target = nil

	if self.single then
		current_target = self.target
	else
		-- find valid targets
		local units = FindUnitsInRadius(
			self.caster:GetTeamNumber(),	-- int, your team number
			self.caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			self.target_team,	-- int, team filter
			self.target_type,	-- int, type filter
			self.target_flags,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- select valid target
		for _,unit in pairs(units) do
			-- not already a multicast target
			if not self.targets[unit] then

				-- check filter
				local filter = false
				if self.ability.CastFilterResultTarget then -- for customs
					filter = self.ability:CastFilterResultTarget( unit ) == UF_SUCCESS
				else
					filter = true
				end

				if filter then
					-- register unit
					self.targets[unit] = true
					current_target = unit

					break
				end
			end
		end

		-- if no one there, break multicast
		if not current_target then
			self:StartIntervalThink( -1 )
			self:Destroy()
			return
		end
	end

	if string.find(self.ability:GetAbilityName(), "midas") then
		if current_target:GetLevel() > self.caster:GetLevel() then return false end
	end

	-- cast to target
	self.caster:SetCursorCastTarget( current_target )
	self.ability:OnSpellStart()

	-- increment count
	self.casts = self.casts + 1
	if self.casts>=(self.multicast-1) then
		self:StartIntervalThink( -1 )
		self:Destroy()
	end

	-- play effects
	self:PlayEffects( self.casts )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ogre_magi_multicast_custom_proc:PlayEffects( value )
	value = value + 1

	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf"

	-- get data
	local counter_speed = 2
	if value==self.multicast then
		counter_speed = 1
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self.caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( value, counter_speed, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound = math.min( value-1, 3 )
	local sound_cast = "Hero_OgreMagi.Fireblast.x" .. sound
	if sound>0 then
		EmitSoundOn( sound_cast, self.caster )
	end
end

ogre_magi_multicast_custom = class({})
LinkLuaModifier( "modifier_ogre_magi_multicast_custom", "heroes/hero_ogre_magi/multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_multicast_custom_proc", "heroes/hero_ogre_magi/multicast", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function ogre_magi_multicast_custom:GetIntrinsicModifierName()
	return "modifier_ogre_magi_multicast_custom"
end

--------------------------------------------------------------------------------
-- Item Events
function ogre_magi_multicast_custom:OnInventoryContentsChanged( params )
	local caster = self:GetCaster()

	-- get data
	local scepter = caster:HasScepter()
	local ability = caster:FindAbilityByName( "ogre_magi_unrefined_fireblast_lua" )

	-- if there's no ability, why bother
	if not ability then return end

	ability:SetActivated( scepter )
	ability:SetHidden( not scepter )

	if ability:GetLevel()~=1 then
		ability:SetLevel( 1 )
	end
end
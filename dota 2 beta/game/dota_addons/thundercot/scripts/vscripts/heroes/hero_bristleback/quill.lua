bristleback_quill_spray_custom = class({})
LinkLuaModifier( "modifier_bristleback_quill_spray_custom", "heroes/hero_bristleback/quill", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bristleback_quill_spray_custom_stack", "heroes/hero_bristleback/quill", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_bristleback_quill_spray_custom_autocast", "heroes/hero_bristleback/quill.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

modifier_bristleback_quill_spray_custom_autocast = class(ItemBaseClass)

function modifier_bristleback_quill_spray_custom_autocast:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_bristleback_quill_spray_custom_autocast:OnDeath(event)
    local parent = self:GetParent()
    if parent ~= event.unit then return end
    local ability = parent:FindAbilityByName("bristleback_quill_spray_custom")
    if not ability or ability:GetLevel() < 1 or not ability:GetAutoCastState() then return end
    ability:ToggleAutoCast()
    parent:RemoveModifierByNameAndCaster("modifier_bristleback_quill_spray_custom_autocast", parent)
end

function modifier_bristleback_quill_spray_custom_autocast:OnCreated()
    if not IsServer() then return end

    self:StartIntervalThink(0.1)
end

function modifier_bristleback_quill_spray_custom_autocast:IsHidden()
    return true
end

function modifier_bristleback_quill_spray_custom_autocast:RemoveOnDeath()
    return false
end

function modifier_bristleback_quill_spray_custom_autocast:OnIntervalThink()
    if self:GetParent():IsChanneling() then return end
    
    if self:GetAbility():GetAutoCastState() and self:GetAbility():IsFullyCastable() and self:GetAbility():IsCooldownReady() then
        self:GetAbility():CastAbility()
    end
end

--------------------------------------------------------------------------------
-- Ability Start
function bristleback_quill_spray_custom:OnSpellStart()
    -- unit identifier
    caster = self:GetCaster()

    -- load data
    local radius = self:GetSpecialValueFor("radius")
    local stack_damage = self:GetSpecialValueFor("quill_stack_damage")
    local base_damage = self:GetSpecialValueFor("quill_base_damage")
    local stack_duration = self:GetSpecialValueFor("quill_stack_duration")

    -- Find Units in Radius
    local enemies = FindUnitsInRadius(
        self:GetCaster():GetTeamNumber(),   -- int, your team number
        caster:GetOrigin(), -- point, center point
        nil,    -- handle, cacheUnit. (not known)
        radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- int, flag filter
        0,  -- int, order filter
        false   -- bool, can grow cache
    )

    -- Apply Damage  
    local damageTable = {
        attacker = caster,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self, --Optional.
    }

    local strengthDamageBonus = caster:GetStrength() * (self:GetSpecialValueFor("strength_damage_bonus_pct")/100)

    for _,enemy in pairs(enemies) do
        -- find stack
        local stack = 0
        local modifier = enemy:FindModifierByNameAndCaster( "modifier_bristleback_quill_spray_custom", caster )
        if modifier~=nil then
            stack = modifier:GetStackCount()
        end

        -- damage
        damageTable.victim = enemy
        damageTable.damage = (base_damage + strengthDamageBonus) + (stack * (stack_damage+strengthDamageBonus))
        ApplyDamage( damageTable )

        -- Add modifier
        enemy:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_bristleback_quill_spray_custom", -- modifier name
            { stack_duration = stack_duration } -- kv
        )

        -- Effects
        self:PlayEffects2( enemy )
    end

    -- Effects
    self:PlayEffects1()
end

--------------------------------------------------------------------------------
-- Helper
function bristleback_quill_spray_custom:GetAT()
    if self.abilityTable==nil then
        self.abilityTable = {}
    end
    return self.abilityTable
end

function bristleback_quill_spray_custom:GetATEmptyKey()
    local table = self:GetAT()
    local i = 1
    while table[i]~=nil do
        i = i+1
    end
    return i
end

function bristleback_quill_spray_custom:AddATValue( value )
    local table = self:GetAT()
    local i = self:GetATEmptyKey()
    table[i] = value
    return i
end

function bristleback_quill_spray_custom:RetATValue( key )
    local table = self:GetAT()
    local ret = table[key]
    table[key] = nil
    return ret
end

--------------------------------------------------------------------------------
-- Effects
function bristleback_quill_spray_custom:PlayEffects1()
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf"
    local sound_cast = "Hero_Bristleback.QuillSpray.Cast"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOn( sound_cast, self:GetCaster() )
end

function bristleback_quill_spray_custom:PlayEffects2( target )
    local particle_cast = "particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf"
    local sound_cast = "Hero_Bristleback.QuillSpray.Target"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOn( sound_cast, self:GetCaster() )
end

modifier_bristleback_quill_spray_custom = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bristleback_quill_spray_custom:IsHidden()
    return false
end

function modifier_bristleback_quill_spray_custom:IsDebuff()
    return true
end

function modifier_bristleback_quill_spray_custom:IsPurgable()
    return false
end

function modifier_bristleback_quill_spray_custom:DestroyOnExpire()
    return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_bristleback_quill_spray_custom:OnCreated( kv )
    if IsServer() then
        -- get AT value
        local at = self:GetAbility():AddATValue( self )

        -- Add stack
        self:GetParent():AddNewModifier(
            self:GetCaster(),
            self:GetAbility(),
            "modifier_bristleback_quill_spray_custom_stack",
            {
                duration = kv.stack_duration,
                modifier = at,
            }
        )

        -- set stack
        self:SetStackCount( 1 )
    end
end

function modifier_bristleback_quill_spray_custom:OnRefresh( kv )
    if IsServer() then
        -- get AT value
        local at = self:GetAbility():AddATValue( self )

        -- Add stack
        local mod = self:GetParent():AddNewModifier(
            self:GetCaster(),
            self:GetAbility(),
            "modifier_bristleback_quill_spray_custom_stack",
            {
                duration = kv.stack_duration,
                modifier = at,
            }
        )

        -- increment stack
        self:IncrementStackCount()
    end
end

function modifier_bristleback_quill_spray_custom:OnDestroy( kv )
end

--------------------------------------------------------------------------------
-- Helper
function modifier_bristleback_quill_spray_custom:RemoveStack( kv )
    if self:IsNull() or not self or self == nil or type(self) == "[none]" then return end

    self:DecrementStackCount()
    if self:GetStackCount()<1 then
        self:Destroy()
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_bristleback_quill_spray_custom:GetEffectName()
    return "particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit_creep.vpcf"
end

function modifier_bristleback_quill_spray_custom:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_bristleback_quill_spray_custom_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bristleback_quill_spray_custom_stack:IsHidden()
    return true
end

function modifier_bristleback_quill_spray_custom_stack:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_bristleback_quill_spray_custom_stack:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_bristleback_quill_spray_custom_stack:OnCreated( kv )
    if IsServer() then
        -- references
        self.parent = self:GetAbility():RetATValue( kv.modifier )
    end
end

function modifier_bristleback_quill_spray_custom_stack:OnRefresh( kv )

end

function modifier_bristleback_quill_spray_custom_stack:OnDestroy( kv )
    if IsServer() then
        self.parent:RemoveStack()
    end
end
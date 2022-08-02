LinkLuaModifier("modifier_windranger_powershot_custom", "heroes/hero_windrunner/powershot_custom", LUA_MODIFIER_MOTION_NONE)

local BaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}
windranger_powershot_custom = class(BaseClass)
modifier_windranger_powershot_custom = class(windranger_powershot_custom)

function windranger_powershot_custom:GetIntrinsicModifierName()
    return "modifier_windranger_powershot_custom"
end
--------------------------------------------------------------------------------
-- Projectile
-- projectile data table
_G.windranger_powershot_custom_projectiles = {}

function windranger_powershot_custom:OnProjectileHitHandle( target, location, handle )
    if not target then
        -- unregister projectile
        _G.windranger_powershot_custom_projectiles[handle] = nil

        -- create Vision
        local vision_radius = self:GetSpecialValueFor( "vision_radius" )
        local vision_duration = self:GetSpecialValueFor( "vision_duration" )
        AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision_radius, vision_duration, false )

        return
    end

    -- get data
    local data = _G.windranger_powershot_custom_projectiles[handle]
    local damage = data.damage

    -- damage
    local damageTable = {
        victim = target,
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self, --Optional.
    }
    ApplyDamage(damageTable)

    -- reduce damage
    data.damage = damage

    -- Play effects
    local sound_cast = "Hero_Windrunner.PowershotDamage"
    EmitSoundOn( sound_cast, target )
end

function windranger_powershot_custom:OnProjectileThink( location )
    -- destroy trees
    local tree_width = self:GetSpecialValueFor( "tree_width" )
    GridNav:DestroyTreesAroundPoint(location, tree_width, false)    
end
----------
function modifier_windranger_powershot_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK
    }
    return funcs
end

function modifier_windranger_powershot_custom:OnAttack(event)
    local unit = event.attacker
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local victim = event.target

    if unit ~= parent then
        return
    end

    if not caster:IsAlive() or caster:PassivesDisabled() or caster:IsIllusion() then
        return
    end

    if event.attacker:IsIllusion() then return end

    local ability = self:GetAbility()
    local chance = ability:GetSpecialValueFor("chance")

    if not ability:IsCooldownReady() then return end
    if not RollPercentage(chance) then return end

    --local point = self:GetCursorPosition()
    local point = caster:GetForwardVector()
    --local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()

    -- load data
    local damage = ability:GetSpecialValueFor( "powershot_damage" ) + (caster:GetIntellect() * (ability:GetSpecialValueFor("int_damage")/100))
    local vision_radius = ability:GetSpecialValueFor( "vision_radius" )
    
    local projectile_name = "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf"
    local projectile_speed = ability:GetSpecialValueFor( "arrow_speed" )
    local projectile_distance = ability:GetSpecialValueFor( "arrow_range" )
    local projectile_radius = ability:GetSpecialValueFor( "arrow_width" )
    local projectile_direction = point
    projectile_direction.z = 0
    projectile_direction = projectile_direction:Normalized()

    -- create projectile
    local info = {
        Source = caster,
        Ability = ability,
        vSpawnOrigin = caster:GetAbsOrigin(),
        
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        
        EffectName = projectile_name,
        fDistance = projectile_distance,
        fStartRadius = projectile_radius,
        fEndRadius = projectile_radius,
        vVelocity = projectile_direction * projectile_speed,
    
        bProvidesVision = true,
        iVisionRadius = vision_radius,
        iVisionTeamNumber = caster:GetTeamNumber(),
    }
    local projectile = ProjectileManager:CreateLinearProjectile(info)

    -- register projectile data
    _G.windranger_powershot_custom_projectiles[projectile] = {}
    _G.windranger_powershot_custom_projectiles[projectile].damage = damage

    -- Play effects
    local sound_cast = "Hero_Windrunner.Powershot.FalconBow"
    EmitSoundOn( sound_cast, caster )
    ability:UseResources(false, false, true)
end
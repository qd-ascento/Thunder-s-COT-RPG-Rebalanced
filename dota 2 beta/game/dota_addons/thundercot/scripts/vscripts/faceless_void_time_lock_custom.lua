LinkLuaModifier("modifier_faceless_void_time_lock_custom", "faceless_void_time_lock_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_faceless_void_time_lock_custom_debuff", "faceless_void_time_lock_custom.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassDebuff = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return true end,
    IsDebuff = function(self) return true end,
}

faceless_void_time_lock_custom = class(ItemBaseClass)
modifier_faceless_void_time_lock_custom = class(faceless_void_time_lock_custom)
modifier_faceless_void_time_lock_custom_debuff = class(ItemBaseClassDebuff)
-------------
function faceless_void_time_lock_custom:GetIntrinsicModifierName()
    return "modifier_faceless_void_time_lock_custom"
end

function modifier_faceless_void_time_lock_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED 
    }
    return funcs
end

function modifier_faceless_void_time_lock_custom:OnCreated()
    self.parent = self:GetParent()
end

function modifier_faceless_void_time_lock_custom:OnAttackLanded(event)
    local unit = event.attacker
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local victim = event.target

    if unit ~= parent then
        return
    end

    if unit:IsIllusion() then return end

    if event.damage_type ~= DAMAGE_TYPE_PHYSICAL or event.inflictor ~= nil or event.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK or not caster:IsAlive() or caster:PassivesDisabled() then
        return
    end
    
    local chance = ability:GetLevelSpecialValueFor("chance", (ability:GetLevel() - 1))

    if not RollPercentage(chance) then
        return
    end

    local stackDuration = ability:GetLevelSpecialValueFor("stack_duration", (ability:GetLevel() - 1))
    local maxStacks = ability:GetLevelSpecialValueFor("max_stacks", (ability:GetLevel() - 1))
    local increasePerStack = ability:GetLevelSpecialValueFor("increase_per_stack", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))

    local victims = FindUnitsInRadius(caster:GetTeam(), parent:GetAbsOrigin(), nil,
            radius, DOTA_UNIT_TARGET_TEAM_ENEMY, bit.bor(DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC), DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST, false)

    for i = 1, #victims, 1 do
        local enemy = victims[i]
        if not enemy:IsAlive() then break end

        Timers:CreateTimer(((1/#victims) * i), function()
            local modifierName = "modifier_faceless_void_time_lock_custom_debuff"
            local enemyStacks = enemy:FindModifierByNameAndCaster(modifierName, caster)

            if enemy:IsAlive() then
                if enemyStacks == nil then
                    enemy:AddNewModifier(caster, ability, "modifier_faceless_void_time_lock_custom_debuff", { duration = stackDuration }):SetStackCount(1)
                elseif enemyStacks:GetStackCount() < maxStacks then
                    enemyStacks:SetStackCount(enemyStacks:GetStackCount() + 1)
                    enemyStacks:ForceRefresh()
                end

                local bonusDamage = 0
                if enemyStacks ~= nil then
                    bonusDamage = (event.damage * ((increasePerStack * enemyStacks:GetStackCount()) / 100)) + (unit:GetAgility() * (ability:GetSpecialValueFor("damage_from_agi")/100))
                end

                ApplyDamage({
                    victim = enemy, 
                    attacker = caster, 
                    damage = event.damage + bonusDamage, 
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION 
                })

                self:PlayEffects(enemy)
            end
        end)
    end
end

function modifier_faceless_void_time_lock_custom:PlayEffects(target)
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf"
    local sound_cast = "Hero_FacelessVoid.TimeLockImpact"

    -- Get Data
    local forward = (target:GetOrigin()-self.parent:GetOrigin()):Normalized()

    -- Create Particle
    local particle = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, target )
    ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() )
    ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin() )
    ParticleManager:SetParticleControlEnt(particle, 2, self.parent, PATTACH_CUSTOMORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)

    -- Create Sound
    EmitSoundOn( sound_cast, target )
end
-----
function modifier_faceless_void_time_lock_custom_debuff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
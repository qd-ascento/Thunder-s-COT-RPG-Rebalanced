LinkLuaModifier("modifier_boss_reef", "bosses/reef.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_reef_follower", "bosses/reef.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_reef_invulnerable", "bosses/reef.lua", LUA_MODIFIER_MOTION_NONE)

local BaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

boss_reef = class(BaseClass)
modifier_boss_reef = class(boss_reef)
modifier_boss_reef_follower = class(boss_reef)
modifier_boss_reef_invulnerable = class(boss_reef)
--------------------
-- BOSS VARIABLES --
--------------------
BOSS_STAGE = 1
BOSS_MAX_STAGE = 3
PARTICLE_ID = nil

BOSS_NAME = "npc_dota_creature_80_boss"
--------------------
function boss_reef:GetIntrinsicModifierName()
    return "modifier_boss_reef"
end
---
function modifier_boss_reef_invulnerable:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_CANNOT_TARGET_ENEMIES] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_ROOTED] = true,
    }
    return state
end


function modifier_boss_reef_invulnerable:OnCreated()
    if not IsServer() then return end

    self:StartIntervalThink(3.0)
end

function modifier_boss_reef_invulnerable:OnIntervalThink()
    local parent = self:GetParent()

    local reef = parent:FindAbilityByName("boss_reef_shadow_dance_inf")
    if not reef or reef:GetLevel() < 1 then return end

    parent:CastAbilityImmediately(reef, 1)
end
---
function modifier_boss_reef:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, --GetModifierHealthRegenPercentage
    }
    return funcs
end

function modifier_boss_reef:CheckState()
    local state = {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR_FOR_ENEMIES] = true
    }

    return state
end

function modifier_boss_reef:GetModifierProvidesFOWVision()
    return 1
end

function modifier_boss_reef:OnTakeDamage(event)
    if not IsServer() then return end

    if event.unit ~= self.boss then return end

    self.canRegen = false
    if self.regenTimer ~= nil then
        Timers:RemoveTimer(self.regenTimer)
    end
    
    self.regenTimer = Timers:CreateTimer(5.0, function()
        self.canRegen = true
    end)
end

function modifier_boss_reef:GetModifierHealthRegenPercentage()
    if self.canRegen then return 10 end
end

function modifier_boss_reef:OnCreated(kv)
    if not IsServer() then return end

    self.boss = self:GetParent()
    self.spawnPosition = Vector(kv.posX, kv.posY, kv.posZ)
    self.canRegen = true
    self.regenTimer = nil

    if BOSS_STAGE >= 1 and 
    not self.boss:FindAbilityByName("boss_reef_essence_shift") then 
        self.boss:AddAbility("boss_reef_essence_shift") 
    end

    if BOSS_STAGE >= 1 and 
    not self.boss:FindAbilityByName("boss_reef_shadow_dance") then 
        self.boss:AddAbility("boss_reef_shadow_dance") 
    end

    -- Making sure they get leveled up properly --
    Timers:CreateTimer(1.0, function()
        for i = 0, self.boss:GetAbilityCount() - 1 do
            local abil = self.boss:GetAbilityByIndex(i)
            if abil ~= nil then
                abil:SetLevel(BOSS_STAGE)
            end
        end
    end)

    self:StartIntervalThink(1.0)
end

function modifier_boss_reef:OnIntervalThink()
    if not self.boss:IsAttacking() then return end

    if self.boss:GetHealthPercent() <= 30 then
        local ability = self.boss:FindAbilityByName("boss_reef_shadow_dance")
        if not ability or ability:GetLevel() < 1 then return end
        if not ability:IsCooldownReady() then return end

        self.boss:CastAbilityImmediately(ability, 1)
        ability:UseResources(false, false, true)
    end
end

function modifier_boss_reef:IsFollower(follower)
    if not follower or follower:IsNull() then return false end

    if follower:GetUnitName() == "npc_dota_creature_130_crip2_death" then return true end
    if follower:GetUnitName() == "npc_dota_creature_130_crip1_death" then return true end

    return false
end

function modifier_boss_reef:ProgressToNext()
    if PARTICLE_ID ~= nil then
        ParticleManager:DestroyParticle(PARTICLE_ID, true)
        ParticleManager:ReleaseParticleIndex(PARTICLE_ID)
    end

    --todo: you also need to apply the new stage abilities to them when they respawn.
    --this just updates the currently spawned units.
    local followers = FindUnitsInRadius(self.boss:GetTeam(), self.boss:GetAbsOrigin(), nil,
        99999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, bit.bor(DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO), DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST, false)

    for _,minion in ipairs(followers) do
        if minion:GetUnitName() == "npc_dota_creature_130_crip2_death" or
        minion:GetUnitName() == "npc_dota_creature_130_crip1_death" then
            minion:FindModifierByNameAndCaster("modifier_boss_reef_follower", minion):ForceRefresh()
        end
    end

    EmitSoundOn("Hero_OgreMagi.Bloodlust.Target", self:GetParent())
end

function modifier_boss_reef:OnDeath(event)
    if not IsServer() then return end

    local victim = event.unit

    if victim ~= self:GetParent() then return end

    local respawnTime = 60

    Timers:CreateTimer(respawnTime, function()
        CreateUnitByNameAsync(BOSS_NAME, self.spawnPosition, true, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
            --Async is faster and will help reduce stutter
            unit:AddNewModifier(unit, nil, "modifier_boss_reef", {
                posX = self.spawnPosition.x,
                posY = self.spawnPosition.y,
                posZ = self.spawnPosition.z,
            })
        end)
    end)

    if BOSS_STAGE < BOSS_MAX_STAGE then
        BOSS_STAGE = BOSS_STAGE + 1

        self:ProgressToNext()
    end

    local heroes = HeroList:GetAllHeroes()
    for _,hero in ipairs(heroes) do
        if UnitIsNotMonkeyClone(hero) then
            if PlayerResource:GetConnectionState(hero:GetPlayerID()) == DOTA_CONNECTION_STATE_CONNECTED then
                if hero:GetTeam() == event.attacker:GetTeam() then
                    if hero:FindItemInAnyInventory("item_elder_soul") == nil then
                        hero:AddItemByName("item_elder_soul")
                    end
                    
                    hero:ModifyGold(1000, false, 0)
                end
            end
        end
    end
end
-----------
function modifier_boss_reef_follower:DeclareFunctions(props)
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_boss_reef_follower:OnCreated(kv)
    if not IsServer() then return end

    self.spawnPosition = Vector(kv.posX, kv.posY, kv.posZ)

    self:StartIntervalThink(1.0)
end

function modifier_boss_reef_follower:CheckState()
    local state = {
        --[MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
    return state
end

function modifier_boss_reef_follower:OnIntervalThink()
    local parent = self:GetParent()

    if parent:IsAttacking() and parent:IsAlive() then
        local hazard = parent:FindAbilityByName("follower_reef_amplify_damage")
        if not hazard then return end
        if not hazard:IsCooldownReady() then return end

        local victims = FindUnitsInRadius(parent:GetTeam(), parent:GetAbsOrigin(), nil,
            hazard:GetSpecialValueFor("AbilityCastRange"), DOTA_UNIT_TARGET_TEAM_ENEMY, bit.bor(DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO), DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST, false)

        if #victims < 1 then return end
        local victim = victims[1]

        victim:AddNewModifier(parent, hazard, "modifier_slardar_amplify_damage", { duration = hazard:GetSpecialValueFor("duration") })
        hazard:UseResources(false, false, true)
        --

        local anchor = parent:FindAbilityByName("follower_reef_anchor_smash")
        if not anchor then return end
        if not anchor:IsCooldownReady() then return end

        parent:CastAbilityImmediately(anchor, 1)
    end
end

function modifier_boss_reef_follower:OnDeath(event)
    if not IsServer() then return end

    local parent = self:GetParent()
    local unitName = parent:GetUnitName()

    if event.unit ~= parent then return end

    local respawnTime = 30

    if GetMapName() == "tcotrpg_1v1" then amountTime = 15 end


    Timers:CreateTimer(respawnTime, function()
      CreateUnitByNameAsync(unitName, self.spawnPosition, true, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
            --Async is faster and will help reduce stutter
            unit:AddNewModifier(unit, nil, "modifier_boss_reef_follower", {
                posX = self.spawnPosition.x,
                posY = self.spawnPosition.y,
                posZ = self.spawnPosition.z,
            })

            if RollPercentage(5) then
                unit:SetRenderColor(255, 215, 0)
                unit:SetModelScale(unit:GetModelScale() * 1.2)
                unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty() * 2.0)
                unit:SetMinimumGoldBounty(unit:GetMaximumGoldBounty() * 2.0)
                local hp = unit:GetMaxHealth() * 1.30
                if hp > INT_MAX_LIMIT or hp <= 0 then
                    hp = INT_MAX_LIMIT
                end

                unit:SetBaseMaxHealth(hp)
                unit:SetMaxHealth(hp)
                unit:SetHealth(hp)
            end

            if modifier_boss_reef:IsFollower(unit) then unit:AddNewModifier(unit, nil, "modifier_boss_reef_follower", {}):ForceRefresh() end
        end)
    end)
end

function modifier_boss_reef_follower:OnRefresh()
    if not IsServer() then return end

    local parent = self:GetParent()

    if BOSS_STAGE >= 1 and 
    not parent:FindAbilityByName("follower_reef_kraken_shell") then 
        parent:AddAbility("follower_reef_kraken_shell") 
    end

    if BOSS_STAGE >= 2 and 
    (KILL_VOTE_RESULT:upper() == "HARD" or KILL_VOTE_RESULT:upper() == "UNFAIR" or KILL_VOTE_RESULT:upper() == "IMPOSSIBLE" or KILL_VOTE_RESULT:upper() == "HELL" or KILL_VOTE_RESULT:upper() == "HARDCORE") and 
    not parent:FindAbilityByName("follower_reef_amplify_damage") then 
        parent:AddAbility("follower_reef_amplify_damage") 
    end

    if BOSS_STAGE >= 3 and 
    (KILL_VOTE_RESULT:upper() == "UNFAIR" or KILL_VOTE_RESULT:upper() == "IMPOSSIBLE" or KILL_VOTE_RESULT:upper() == "HELL" or KILL_VOTE_RESULT:upper() == "HARDCORE") and 
    not parent:FindAbilityByName("follower_reef_anchor_smash") then 
        parent:AddAbility("follower_reef_anchor_smash")
    end

    -- Making sure they get leveled up properly --
    Timers:CreateTimer(1.0, function()
        for i = 0, parent:GetAbilityCount() - 1 do
            local abil = parent:GetAbilityByIndex(i)
            if abil ~= nil then
                abil:SetLevel(BOSS_STAGE)
            end
        end
    end)
end

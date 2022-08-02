LinkLuaModifier("modifier_boss_skafian", "bosses/skafian.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_skafian_follower", "bosses/skafian.lua", LUA_MODIFIER_MOTION_NONE)

local BaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

boss_skafian = class(BaseClass)
modifier_boss_skafian = class(boss_skafian)
modifier_boss_skafian_follower = class(boss_skafian)
--------------------
-- BOSS VARIABLES --
--------------------
BOSS_STAGE = 1
BOSS_MAX_STAGE = 3
PARTICLE_ID = nil

BOSS_NAME = "npc_dota_creature_30_boss"
--------------------
function boss_skafian:GetIntrinsicModifierName()
    return "modifier_boss_skafian"
end

function modifier_boss_skafian:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, --GetModifierHealthRegenPercentage
    }
    return funcs
end

function modifier_boss_skafian:CheckState()
    local state = {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR_FOR_ENEMIES] = true
    }

    return state
end

function modifier_boss_skafian:GetModifierProvidesFOWVision()
    return 1
end

function modifier_boss_skafian:OnTakeDamage(event)
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

function modifier_boss_skafian:GetModifierHealthRegenPercentage()
    if self.canRegen then return 10 end
end

function modifier_boss_skafian:OnCreated(kv)
    if not IsServer() then return end

    self.boss = self:GetParent()
    self.spawnPosition = Vector(kv.posX, kv.posY, kv.posZ)
    self.canRegen = true
    self.regenTimer = nil

    if BOSS_STAGE >= 1 and 
    not self.boss:FindAbilityByName("boss_skafian_entangle") then 
        self.boss:AddAbility("boss_skafian_entangle") 
    end

    if BOSS_STAGE >= 2 and 
    (KILL_VOTE_RESULT:upper() == "HARD" or KILL_VOTE_RESULT:upper() == "UNFAIR" or KILL_VOTE_RESULT:upper() == "IMPOSSIBLE" or KILL_VOTE_RESULT:upper() == "HELL" or KILL_VOTE_RESULT:upper() == "HARDCORE") and 
    not self.boss:FindAbilityByName("boss_skafian_fury_swipes") then 
        self.boss:AddAbility("boss_skafian_fury_swipes") 
    end

    if BOSS_STAGE >= 3 and 
    (KILL_VOTE_RESULT:upper() == "UNFAIR" or KILL_VOTE_RESULT:upper() == "IMPOSSIBLE" or KILL_VOTE_RESULT:upper() == "HELL" or KILL_VOTE_RESULT:upper() == "HARDCORE") and 
    not self.boss:FindAbilityByName("boss_skafian_enrage") then 
        self.boss:AddAbility("boss_skafian_enrage") 
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

function modifier_boss_skafian:OnIntervalThink()
    if self.boss:GetHealthPercent() <= 50 then
        local enrage = self.boss:FindAbilityByName("boss_skafian_enrage")
        if not enrage or enrage:GetLevel() < 1 then return end
        if not enrage:IsCooldownReady() then return end

        self.boss:CastAbilityImmediately(enrage, 1)
        enrage:UseResources(false, false, true)
    end
end

function modifier_boss_skafian:IsFollower(follower)
    if not follower or follower:IsNull() then return false end

    if follower:GetUnitName() == "npc_dota_creature_1_crip" then return true end
    if follower:GetUnitName() == "npc_dota_creature_10_crip_2" then return true end
    if follower:GetUnitName() == "npc_dota_creature_10_crip_3" then return true end
    if follower:GetUnitName() == "npc_dota_creature_10_crip_4" then return true end
    if follower:GetUnitName() == "npc_dota_creature_30_crip" then return true end
    if follower:GetUnitName() == "npc_dota_creature_30_crip_2" then return true end

    return false
end

function modifier_boss_skafian:ProgressToNext()
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
        if minion:GetUnitName() == "npc_dota_creature_1_crip" or 
        minion:GetUnitName() == "npc_dota_creature_10_crip_2" or 
        minion:GetUnitName() == "npc_dota_creature_10_crip_3" or 
        minion:GetUnitName() == "npc_dota_creature_10_crip_4" or 
        minion:GetUnitName() == "npc_dota_creature_30_crip_2" or 
        minion:GetUnitName() == "npc_dota_creature_30_crip" then
            minion:FindModifierByNameAndCaster("modifier_boss_skafian_follower", minion):ForceRefresh()
        end
    end

    EmitSoundOn("Hero_OgreMagi.Bloodlust.Target", self:GetParent())
end

function modifier_boss_skafian:OnDeath(event)
    if not IsServer() then return end

    local victim = event.unit

    if victim ~= self:GetParent() then return end

    local respawnTime = 60

    Timers:CreateTimer(respawnTime, function()
        CreateUnitByNameAsync(BOSS_NAME, self.spawnPosition, true, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
            --Async is faster and will help reduce stutter
            unit:AddNewModifier(unit, nil, "modifier_boss_skafian", {
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
                    if hero:FindItemInAnyInventory("item_forest_soul") == nil then
                        hero:AddItemByName("item_forest_soul")
                    end
                    
                    hero:ModifyGold(1000, false, 0)
                end
            end
        end
    end
end
-----------
function modifier_boss_skafian_follower:DeclareFunctions(props)
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_boss_skafian_follower:OnCreated(kv)
    if not IsServer() then return end

    self.spawnPosition = Vector(kv.posX, kv.posY, kv.posZ)

    self:StartIntervalThink(1.0)
end

function modifier_boss_skafian_follower:CheckState()
    local state = {
        --[MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
    return state
end

function modifier_boss_skafian_follower:OnIntervalThink()
    local parent = self:GetParent()

    if parent:IsAttacking() and parent:IsAlive() then
        local overpower = parent:FindAbilityByName("follower_skafian_overpower")
        if not overpower or overpower:GetLevel() < 1 then return end
        if not overpower:IsCooldownReady() then return end

        parent:CastAbilityImmediately(overpower, 1)
        overpower:UseResources(false, false, true)
    end
end

function modifier_boss_skafian_follower:OnDeath(event)
    if not IsServer() then return end

    local parent = self:GetParent()
    local unitName = parent:GetUnitName()

    if event.unit ~= parent then return end

    local respawnTime = 30

    if GetMapName() == "tcotrpg_1v1" then amountTime = 15 end


    Timers:CreateTimer(respawnTime, function()
      CreateUnitByNameAsync(unitName, self.spawnPosition, true, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
            --Async is faster and will help reduce stutter
            unit:AddNewModifier(unit, nil, "modifier_boss_skafian_follower", {
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

            if modifier_boss_skafian:IsFollower(unit) then unit:AddNewModifier(unit, nil, "modifier_boss_skafian_follower", {}):ForceRefresh() end
        end)
    end)
end

function modifier_boss_skafian_follower:OnRefresh()
    if not IsServer() then return end

    local parent = self:GetParent()

    if BOSS_STAGE >= 1 and 
    not parent:FindAbilityByName("follower_skafian_filth") then 
        parent:AddAbility("follower_skafian_filth") 
    end

    if BOSS_STAGE >= 2 and 
    (KILL_VOTE_RESULT:upper() == "HARD" or KILL_VOTE_RESULT:upper() == "UNFAIR" or KILL_VOTE_RESULT:upper() == "IMPOSSIBLE" or KILL_VOTE_RESULT:upper() == "HELL" or KILL_VOTE_RESULT:upper() == "HARDCORE") and 
    not parent:FindAbilityByName("follower_skafian_earthshock") then 
        parent:AddAbility("follower_skafian_earthshock") 
    end

    if BOSS_STAGE >= 3 and 
    (KILL_VOTE_RESULT:upper() == "UNFAIR" or KILL_VOTE_RESULT:upper() == "IMPOSSIBLE" or KILL_VOTE_RESULT:upper() == "HELL" or KILL_VOTE_RESULT:upper() == "HARDCORE") and 
    not parent:FindAbilityByName("follower_skafian_overpower") then 
        parent:AddAbility("follower_skafian_overpower") 
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

    if BOSS_STAGE >= 2 then
        -- Get Resources
        --[[
        local particle_cast = "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf"
        local sound_cast = "Hero_OgreMagi.Bloodlust.Target"

        if BOSS_STAGE <= 2 then
            particle_cast = "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
        end

        -- Get Data
        -- Create Particle
        
        local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_OVERHEAD_FOLLOW, parent)
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            0,
            parent,
            PATTACH_OVERHEAD_FOLLOW,
            "attach_hitloc",
            Vector(0,0,0), -- unknown
            true -- unknown, true
        )
        ParticleManager:SetParticleControl(effect_cast, 0, parent:GetOrigin())
        ParticleManager:SetParticleControlForward(effect_cast, 1, parent:GetOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast)

        PARTICLE_ID = effect_cast
    --]]
        -- Create Sound
        
    end
end

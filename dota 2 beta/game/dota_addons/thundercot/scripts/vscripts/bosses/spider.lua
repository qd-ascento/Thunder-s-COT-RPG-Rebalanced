LinkLuaModifier("modifier_boss_spider", "bosses/spider.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_spider_follower", "bosses/spider.lua", LUA_MODIFIER_MOTION_NONE)

local BaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

boss_spider = class(BaseClass)
modifier_boss_spider = class(boss_spider)
modifier_boss_spider_follower = class(boss_spider)
--------------------
-- BOSS VARIABLES --
--------------------
BOSS_STAGE = 1
BOSS_MAX_STAGE = 3
PARTICLE_ID = nil

BOSS_NAME = "npc_dota_creature_40_boss"
--------------------
function boss_spider:GetIntrinsicModifierName()
    return "modifier_boss_spider"
end

function modifier_boss_spider:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, --GetModifierHealthRegenPercentage
    }
    return funcs
end

function modifier_boss_spider:CheckState()
    local state = {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR_FOR_ENEMIES] = true
    }

    return state
end

function modifier_boss_spider:GetModifierProvidesFOWVision()
    return 1
end

function modifier_boss_spider:OnTakeDamage(event)
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

function modifier_boss_spider:GetModifierHealthRegenPercentage()
    if self.canRegen then return 10 end
end

function modifier_boss_spider:OnCreated(kv)
    if not IsServer() then return end

    self.boss = self:GetParent()
    self.spawnPosition = Vector(kv.posX, kv.posY, kv.posZ)
    self.canRegen = true
    self.regenTimer = nil

    if BOSS_STAGE >= 1 and 
    not self.boss:FindAbilityByName("spider_bite_boss") then 
        self.boss:AddAbility("spider_bite_boss") 
    end

    if BOSS_STAGE >= 2 and 
    (KILL_VOTE_RESULT:upper() == "HARD" or KILL_VOTE_RESULT:upper() == "UNFAIR" or KILL_VOTE_RESULT:upper() == "IMPOSSIBLE" or KILL_VOTE_RESULT:upper() == "HELL" or KILL_VOTE_RESULT:upper() == "HARDCORE") and 
    not self.boss:FindAbilityByName("boss_spider_silken_bola") then 
        self.boss:AddAbility("boss_spider_silken_bola") 
    end

    if BOSS_STAGE >= 3 and 
    (KILL_VOTE_RESULT:upper() == "UNFAIR" or KILL_VOTE_RESULT:upper() == "IMPOSSIBLE" or KILL_VOTE_RESULT:upper() == "HELL" or KILL_VOTE_RESULT:upper() == "HARDCORE") and 
    not self.boss:FindAbilityByName("boss_spider_insatiable_hunger") then 
        self.boss:AddAbility("boss_spider_insatiable_hunger") 
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

function modifier_boss_spider:OnIntervalThink()
    if not self.boss:IsAttacking() then return end

    if self.boss:GetHealthPercent() <= 30 then
        local ability = self.boss:FindAbilityByName("boss_spider_insatiable_hunger")
        if not ability or ability:GetLevel() < 1 then return end
        if not ability:IsCooldownReady() then return end

        self.boss:CastAbilityImmediately(ability, 1)
        ability:UseResources(false, false, true)
    end

    local bola = self.boss:FindAbilityByName("boss_spider_silken_bola")
    if not bola then return end
    if not bola:IsCooldownReady() then return end

    local victims = FindUnitsInRadius(self.boss:GetTeam(), self.boss:GetAbsOrigin(), nil,
        bola:GetSpecialValueFor("AbilityCastRange"), DOTA_UNIT_TARGET_TEAM_ENEMY, bit.bor(DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO), DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST, false)

    if #victims < 1 then return end
    local victim = victims[1]

    victim:AddNewModifier(self.boss, bola, "modifier_broodmother_silken_bola", { duration = bola:GetSpecialValueFor("duration") })
    bola:UseResources(false, false, true)
end

function modifier_boss_spider:IsFollower(follower)
    if not follower or follower:IsNull() then return false end

    if follower:GetUnitName() == "npc_dota_creature_40_crip" then return true end
    if follower:GetUnitName() == "npc_dota_creature_40_crip_2" then return true end

    return false
end

function modifier_boss_spider:ProgressToNext()
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
        if minion:GetUnitName() == "npc_dota_creature_40_crip" or
        minion:GetUnitName() == "npc_dota_creature_40_crip_2" then
            minion:FindModifierByNameAndCaster("modifier_boss_spider_follower", minion):ForceRefresh()
        end
    end

    EmitSoundOn("Hero_OgreMagi.Bloodlust.Target", self:GetParent())
end

function modifier_boss_spider:OnDeath(event)
    if not IsServer() then return end

    local victim = event.unit

    if victim ~= self:GetParent() then return end

    local respawnTime = 60

    Timers:CreateTimer(respawnTime, function()
        CreateUnitByNameAsync(BOSS_NAME, self.spawnPosition, true, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
            --Async is faster and will help reduce stutter
            unit:AddNewModifier(unit, nil, "modifier_boss_spider", {
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
                    if hero:FindItemInAnyInventory("item_spider_soul") == nil then
                        hero:AddItemByName("item_spider_soul")
                    end
                    
                    hero:ModifyGold(1000, false, 0)
                end
            end
        end
    end
end
-----------
function modifier_boss_spider_follower:DeclareFunctions(props)
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_boss_spider_follower:OnCreated(kv)
    if not IsServer() then return end

    self.spawnPosition = Vector(kv.posX, kv.posY, kv.posZ)

    self:StartIntervalThink(1.0)
end

function modifier_boss_spider_follower:CheckState()
    local state = {
        --[MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
    return state
end

function modifier_boss_spider_follower:OnIntervalThink()
    local parent = self:GetParent()

    if parent:IsAttacking() and parent:IsAlive() then
        local snare = parent:FindAbilityByName("follower_spider_sticky_snare")
        if not snare or snare:GetLevel() < 1 then return end
        if not snare:IsCooldownReady() then return end

        local victims = FindUnitsInRadius(parent:GetTeam(), parent:GetAbsOrigin(), nil,
            snare:GetSpecialValueFor("AbilityCastRange"), DOTA_UNIT_TARGET_TEAM_ENEMY, bit.bor(DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO), DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST, false)

        if #victims < 1 then return end
        local victim = victims[1]

        parent:CastAbilityOnPosition(victim:GetAbsOrigin(), snare, 1)
        snare:UseResources(false, false, true)
    end
end

function modifier_boss_spider_follower:OnDeath(event)
    if not IsServer() then return end

    local parent = self:GetParent()
    local unitName = parent:GetUnitName()

    if event.unit ~= parent then return end

    local respawnTime = 30

    if GetMapName() == "tcotrpg_1v1" then amountTime = 15 end


    Timers:CreateTimer(respawnTime, function()
      CreateUnitByNameAsync(unitName, self.spawnPosition, true, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
            --Async is faster and will help reduce stutter
            unit:AddNewModifier(unit, nil, "modifier_boss_spider_follower", {
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

            if modifier_boss_spider:IsFollower(unit) then unit:AddNewModifier(unit, nil, "modifier_boss_spider_follower", {}):ForceRefresh() end
        end)
    end)
end

function modifier_boss_spider_follower:OnRefresh()
    if not IsServer() then return end

    local parent = self:GetParent()

    if BOSS_STAGE >= 1 and 
    not parent:FindAbilityByName("broodmother_poison_sting") then 
        parent:AddAbility("broodmother_poison_sting") 
    end

    if BOSS_STAGE >= 2 and 
    (KILL_VOTE_RESULT:upper() == "HARD" or KILL_VOTE_RESULT:upper() == "UNFAIR" or KILL_VOTE_RESULT:upper() == "IMPOSSIBLE" or KILL_VOTE_RESULT:upper() == "HELL" or KILL_VOTE_RESULT:upper() == "HARDCORE") and 
    not parent:FindAbilityByName("spider_bite") then 
        parent:AddAbility("spider_bite") 
    end

    if BOSS_STAGE >= 3 and 
    (KILL_VOTE_RESULT:upper() == "UNFAIR" or KILL_VOTE_RESULT:upper() == "IMPOSSIBLE" or KILL_VOTE_RESULT:upper() == "HELL" or KILL_VOTE_RESULT:upper() == "HARDCORE") and 
    not parent:FindAbilityByName("follower_spider_sticky_snare") then 
        parent:AddAbility("follower_spider_sticky_snare")
    end

    -- Making sure they get leveled up properly --
    Timers:CreateTimer(1.0, function()
        for i = 0, parent:GetAbilityCount() - 1 do
            local abil = parent:GetAbilityByIndex(i)
            if abil ~= nil then
                abil:SetLevel(BOSS_STAGE)
                if abil:GetAbilityName() == "follower_spider_sticky_snare" then
                    abil:SetActivated(true)
                    abil:SetHidden(false)
                end
            end
        end
    end)
end

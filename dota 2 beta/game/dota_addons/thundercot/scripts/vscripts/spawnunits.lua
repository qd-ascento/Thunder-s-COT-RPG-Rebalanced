if modifier_unit_on_death == nil then modifier_unit_on_death = class({}) end
if modifier_unit_out_of_game == nil then modifier_unit_out_of_game = class({}) end
if modifier_unit_boss == nil then modifier_unit_boss = class({}) end
if modifier_unit_boss_2 == nil then modifier_unit_boss_2 = class({}) end

LinkLuaModifier( "modifier_unit_on_death", 'spawnunits', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unit_out_of_game", 'spawnunits', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unit_boss", 'spawnunits', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unit_boss_2", 'spawnunits', LUA_MODIFIER_MOTION_NONE )

require("bosses/skafian")
require("bosses/spider")
require("bosses/reef")
require("bosses/mine")

function modifier_unit_boss:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_unit_boss:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_unit_boss:GetModifierMoveSpeed_Limit()
    return 2000
end

function modifier_unit_boss:GetModifierProvidesFOWVision()
    return 1
end

function modifier_unit_boss:OnDeath(event)
    if self:GetParent() ~= event.unit then
        return
    end

    
end

function modifier_unit_boss:GetModifierStatusResistance()
    if self:GetParent():IsHexed() or self:GetParent():PassivesDisabled() then return 0 end
    return 75
end

function modifier_unit_boss:IsHidden()
    return true
end

function modifier_unit_boss:IsPurgable()
    return false
end

function modifier_unit_boss:CheckState()
    local state = {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = false,
        [MODIFIER_STATE_FLYING] = false,
        [MODIFIER_STATE_FORCED_FLYING_VISION] = false,
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS] = false,
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_FISSURE] = false,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }

    return state
end
--
function modifier_unit_boss_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    }

    return funcs
end


function modifier_unit_boss_2:GetModifierIgnoreMovespeedLimit()
    return 1
end


function modifier_unit_boss_2:GetModifierMoveSpeed_Limit()
    return 2000
end

function modifier_unit_boss_2:GetModifierProvidesFOWVision()
    return 1
end

function modifier_unit_boss_2:GetModifierStatusResistance()
    if self:GetParent():IsHexed() or self:GetParent():PassivesDisabled() then return 0 end

    return 30
end

function modifier_unit_boss_2:IsHidden()
    return true
end

function modifier_unit_boss_2:IsPurgable()
    return false
end

function modifier_unit_boss_2:CheckState()
    local state = {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = false,
        [MODIFIER_STATE_FLYING] = false,
        [MODIFIER_STATE_FORCED_FLYING_VISION] = false,
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS] = false,
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_FISSURE] = false,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }

    return state
end
--

function modifier_unit_out_of_game:CheckState()
    local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
    return state
end

function modifier_unit_out_of_game:OnCreated()
    if not IsServer() then return end

    self:GetCaster():AddNoDraw()
end

function modifier_unit_out_of_game:OnRemoved()
    if not IsServer() then return end

    self:GetCaster():RemoveNoDraw()
end

function modifier_unit_out_of_game:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_unit_on_death:OnCreated(kv)
  if not IsServer() then return end

  self.spawnPos = Vector(kv.posX, kv.posY, kv.posZ)
  self.unitName = kv.name
  self.unit = self:GetParent()

  self:StartIntervalThink(1.0)
end

function modifier_unit_on_death:OnIntervalThink()
    local watchForDuel = CustomNetTables:GetTableValue("duel", "game_info")
    if watchForDuel ~= nil then
        if watchForDuel.active == 1 then 
            if not self.unit:HasModifier("modifier_unit_out_of_game") then
                self.unit:AddNewModifier(self.unit, nil, "modifier_unit_out_of_game", {})
            end
        elseif watchForDuel.active == 0 then
            if self.unit:HasModifier("modifier_unit_out_of_game") then
                self.unit:RemoveModifierByName("modifier_unit_out_of_game")
            end
        end
    else
        if self.unit:HasModifier("modifier_unit_out_of_game") then
            self.unit:RemoveModifierByName("modifier_unit_out_of_game")
        end
    end
end

function modifier_unit_on_death:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_DEATH
  }

  return funcs
end

function modifier_unit_on_death:IsHidden()
  return true
end

function modifier_unit_on_death:CheckState()
    local states = {
        --[MODIFIER_STATE_NO_HEALTH_BAR] = true
    }

    return states
end

--------------------------------------------------------------------------------

function modifier_unit_on_death:IsPurgable()
  return false
end

function modifier_unit_on_death:OnDeath(event)
    if not IsServer() then return end

    local creep = event.unit
    
    if creep ~= self:GetParent() then
        return
    end

    if creep:GetUnitName() == "npc_dota_creature_100_boss" then return end
    if creep:GetUnitName() == "npc_dota_creature_100_boss_2" then return end
    if creep:GetUnitName() == "npc_dota_creature_100_boss_3" then return end
    if creep:GetUnitName() == "npc_dota_creature_100_boss_4" then return end
    if creep:GetUnitName() == "npc_dota_creature_100_boss_5" then
        GameRules:SetGameWinner(event.attacker:GetTeamNumber())
        return
    end

    local amountTime = 30
    if GetMapName() == "tcotrpg_1v1" then
        amountTime = 15
    end

    if IsBossTCOTRPG(creep) then
        amountTime = 60
    end

    if (creep:GetUnitName() == "npc_dota_creature_140_crip_Robo" or creep:GetUnitName() == "npc_dota_creature_100_crip" or creep:GetUnitName() == "npc_dota_creature_100_crip_2") then
        amountTime = 0.1
    end

    if (creep:GetUnitName() == "npc_dota_creature_140_crip_Robo") then
        local mode = KILL_VOTE_RESULT:upper()
        local lostChance = 0.5

        if mode == "EASY" then 
            lostChance = 50
        elseif mode == "NORMAL" then
            lostChance = 20
        else
            lostChance = 10
        end

        if RandomFloat(0.0, 100.0) <= lostChance then
            DropNeutralItemAtPositionForHero("item_last_soul", creep:GetAbsOrigin(), creep, 1, false)
        end
    end

    if creep:GetUnitName() == "npc_dota_creature_150_boss_last" then
        amountTime = 180
    end

    if IsBossTCOTRPG(creep) then
        local soulDrop = ""
        local bossName = creep:GetUnitName()
        if bossName == "npc_dota_creature_40_boss_2" then
            soulDrop = "item_spider_soul"
        elseif bossName == "npc_dota_creature_50_boss" then
            soulDrop = "item_reef_soul"
        elseif bossName == "npc_dota_creature_130_boss_death" then
            soulDrop = "item_reef_soul"
        elseif bossName == "npc_dota_creature_80_boss" then
            soulDrop = "item_elder_soul"
        elseif bossName == "npc_dota_creature_roshan_boss" then
            soulDrop = "item_roshan_soul"
        end

        local heroes = HeroList:GetAllHeroes()
        for _,hero in ipairs(heroes) do
            if UnitIsNotMonkeyClone(hero) then
                if PlayerResource:GetConnectionState(hero:GetPlayerID()) == DOTA_CONNECTION_STATE_CONNECTED then
                    if hero:GetTeam() == event.attacker:GetTeam() then
                        if hero:FindItemInAnyInventory(soulDrop) == nil then
                            hero:AddItemByName(soulDrop)
                        end
                        hero:ModifyGold(1000, false, 0)
                    end
                end
            end
        end
    end

    --[[
    if IsCreepTCOTRPG(creep) then
        if RandomFloat(0.0, 100.0) <= _G.morplingPartChance then
            local weapons = {
                "item_piece",
                "item_piece2",
                "item_piece3",
                "item_piece4",
                "item_piece5",
            }
            local chosenDrop = RandomInt(1, #weapons)
            DropNeutralItemAtPositionForHero(weapons[chosenDrop], event.attacker:GetAbsOrigin(), event.attacker, 1, false)
        end
    end
    --]]
    
    Timers:CreateTimer(amountTime, function()
      CreateUnitByNameAsync(self.unitName, self.spawnPos, true, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
            --Async is faster and will help reduce stutter
            unit:AddNewModifier(unit, nil, "modifier_unit_on_death", {
                posX = self.spawnPos.x,
                posY = self.spawnPos.y,
                posZ = self.spawnPos.z,
                name = self.unitName
            })
            if unit:GetUnitName() == "npc_dota_creature_150_boss_last" then
                unit:AddNewModifier(unit, nil, "modifier_boss_zeus_secret", {})
            end

            if IsBossTCOTRPG(unit) then
                if unit:GetUnitName() == "npc_dota_creature_100_boss_2" or unit:GetUnitName() == "npc_dota_creature_100_boss" or unit:GetUnitName() == "npc_dota_creature_150_boss_last" then
                    unit:AddNewModifier(unit, nil, "modifier_unit_boss", {})
                else
                    unit:AddNewModifier(unit, nil, "modifier_unit_boss_2", {})
                end
            else
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
            end
        end)
    end)
end

function SpawnAllUnits()
    function SpawnUnitsInZone(zoneName, unitName, max, boss)
        local zones = Entities:FindAllByName(zoneName)

        for _, zone in ipairs(zones) do
            local point = zone:GetAbsOrigin() + RandomVector(RandomFloat( 0, 10))
            
            for i = 1, max do
                CreateUnitByNameAsync(unitName, point, true, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
                    --Async is faster and will help reduce stutter
                    if modifier_boss_skafian:IsFollower(unit) then 
                        unit:AddNewModifier(unit, nil, "modifier_boss_skafian_follower", {
                            posX = unit:GetAbsOrigin().x,
                            posY = unit:GetAbsOrigin().y,
                            posZ = unit:GetAbsOrigin().z,
                        }):ForceRefresh() 
                    elseif modifier_boss_reef:IsFollower(unit) then 
                        unit:AddNewModifier(unit, nil, "modifier_boss_reef_follower", {
                            posX = unit:GetAbsOrigin().x,
                            posY = unit:GetAbsOrigin().y,
                            posZ = unit:GetAbsOrigin().z,
                        }):ForceRefresh() 
                    elseif modifier_boss_spider:IsFollower(unit) then 
                        unit:AddNewModifier(unit, nil, "modifier_boss_spider_follower", {
                            posX = unit:GetAbsOrigin().x,
                            posY = unit:GetAbsOrigin().y,
                            posZ = unit:GetAbsOrigin().z,
                        }):ForceRefresh() 
                    elseif modifier_boss_mine:IsFollower(unit) then 
                        unit:AddNewModifier(unit, nil, "modifier_boss_mine_follower", {
                            posX = unit:GetAbsOrigin().x,
                            posY = unit:GetAbsOrigin().y,
                            posZ = unit:GetAbsOrigin().z,
                        }):ForceRefresh() 
                    else 
                        unit:AddNewModifier(unit, nil, "modifier_unit_on_death", {
                            posX = unit:GetAbsOrigin().x,
                            posY = unit:GetAbsOrigin().y,
                            posZ = unit:GetAbsOrigin().z,
                            name = unitName,
                        })
                    end
                end)
            end
        end
    end

    SpawnUnitsInZone("spawn_creep_1", "npc_dota_creature_1_crip", 1) -- Mole
    SpawnUnitsInZone("spawn_creep_2", "npc_dota_creature_30_crip", 3) -- Bear
    SpawnUnitsInZone("spawn_creep_13", "npc_dota_creature_30_crip_2", 4) -- Wolf
    SpawnUnitsInZone("spawn_creep_3", "npc_dota_creature_40_crip", 1) -- Spider
    SpawnUnitsInZone("spawn_creep_4", "npc_dota_creature_130_crip2_death", 1) -- Zombie in water
    SpawnUnitsInZone("spawn_creep_5", "npc_dota_creature_130_crip1_death", 1) -- Zombie on land
    SpawnUnitsInZone("spawn_creep_6", "npc_dota_creature_120_crip_snow", 1) -- Monkey mobs
    SpawnUnitsInZone("spawn_creep_7", "npc_dota_creature_70_crip", 1) -- Primal Beast mobs
    SpawnUnitsInZone("spawn_creep_15", "npc_dota_creature_70_crip_2", 1) -- Primal Beast mobs
    SpawnUnitsInZone("spawn_creep_8", "npc_dota_creature_50_crip", 3) -- Octo mobs
    SpawnUnitsInZone("spawn_creep_9", "npc_dota_creature_100_crip", 1) -- Nevermore mobs
    SpawnUnitsInZone("spawn_creep_17", "npc_dota_creature_100_crip_2", 1) -- Nevermore mobs
    SpawnUnitsInZone("spawn_creep_10", "npc_dota_creature_10_crip_2", 1)
    SpawnUnitsInZone("spawn_creep_11", "npc_dota_creature_10_crip_3", 1)
    SpawnUnitsInZone("spawn_creep_16", "npc_dota_creature_10_crip_4", 1)
    SpawnUnitsInZone("spawn_creep_12", "npc_dota_creature_140_crip_Robo", 1)
    SpawnUnitsInZone("spawn_target_dummy", "npc_dota_creature_target_dummy", 1)
    SpawnUnitsInZone("spawn_creep_14", "npc_dota_creature_40_crip_2", 1) -- Spider
    --

    function SpawnBossInZone(zoneName, unitName)
        local zones = Entities:FindAllByName(zoneName)

        for _, zone in ipairs(zones) do
            local point = zone:GetAbsOrigin() + RandomVector(RandomFloat( 0, 10))

            CreateUnitByNameAsync(unitName, point, true, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
                --Async is faster and will help reduce stutter
                if unit:GetUnitName() == "npc_dota_creature_100_boss_2" or unit:GetUnitName() == "npc_dota_creature_100_boss" or unit:GetUnitName() == "npc_dota_creature_150_boss_last" then
                    unit:AddNewModifier(unit, nil, "modifier_unit_boss", {})
                else
                    unit:AddNewModifier(unit, nil, "modifier_unit_boss_2", {})
                end

                unit:AddNewModifier(unit, nil, "MODIFIER_STATE_CANNOT_MISS", {})
                unit:AddNewModifier(unit, nil, "MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED", {})

                --
                if unitName == "npc_dota_creature_30_boss" then 
                    unit:AddNewModifier(unit, nil, "modifier_boss_skafian", {
                        posX = unit:GetAbsOrigin().x,
                        posY = unit:GetAbsOrigin().y,
                        posZ = unit:GetAbsOrigin().z,
                    })
                elseif unitName == "npc_dota_creature_80_boss" then 
                    unit:AddNewModifier(unit, nil, "modifier_boss_reef", {
                        posX = unit:GetAbsOrigin().x,
                        posY = unit:GetAbsOrigin().y,
                        posZ = unit:GetAbsOrigin().z,
                    })  
                elseif unitName == "npc_dota_creature_40_boss" then 
                    unit:AddNewModifier(unit, nil, "modifier_boss_spider", {
                        posX = unit:GetAbsOrigin().x,
                        posY = unit:GetAbsOrigin().y,
                        posZ = unit:GetAbsOrigin().z,
                    }) 
                elseif unitName == "npc_dota_creature_70_boss" then 
                    unit:AddNewModifier(unit, nil, "modifier_boss_mine", {
                        posX = unit:GetAbsOrigin().x,
                        posY = unit:GetAbsOrigin().y,
                        posZ = unit:GetAbsOrigin().z,
                    }) 
                else
                    unit:AddNewModifier(unit, nil, "modifier_unit_on_death", {
                        posX = unit:GetAbsOrigin().x,
                        posY = unit:GetAbsOrigin().y,
                        posZ = unit:GetAbsOrigin().z,
                        name = unitName
                    })
                end
                --
            end)
        end
    end

    SpawnBossInZone("spawn_boss_morphling", "npc_dota_creature_80_boss")
    SpawnBossInZone("spawn_boss_enigma", "npc_dota_creature_70_boss")
    SpawnBossInZone("spawn_boss_monkey", "npc_dota_creature_40_boss_2")
    SpawnBossInZone("spawn_boss_skafian2", "npc_dota_creature_30_boss")
    SpawnBossInZone("spawn_boss_spider", "npc_dota_creature_40_boss")
    SpawnBossInZone("spawn_boss_octo", "npc_dota_creature_50_boss")
    SpawnBossInZone("spawn_boss_nevermore", "npc_dota_creature_100_boss")
    SpawnBossInZone("spawn_boss_necro", "npc_dota_creature_130_boss_death")
    SpawnBossInZone("spawn_boss_mole", "npc_dota_creature_10_boss")
    SpawnBossInZone("spawn_boss_kobold", "npc_dota_creature_20_boss")
    SpawnBossInZone("spawn_boss_roshan", "npc_dota_creature_roshan_boss")

    if GetMapName() == "5v5" then
        if _G.SummonedZeus then return end
        CreateUnitByNameAsync("npc_dota_creature_150_boss_last", Entities:FindByName(nil, "spawn_boss_zeus"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
            unit:AddNewModifier(unit, nil, "modifier_unit_boss", {})
            unit:AddNewModifier(unit, nil, "modifier_unit_on_death", {
                posX = unit:GetAbsOrigin().x,
                posY = unit:GetAbsOrigin().y,
                posZ = unit:GetAbsOrigin().z,
                name = "npc_dota_creature_150_boss_last"
            })

            unit:AddNewModifier(unit, nil, "MODIFIER_STATE_CANNOT_MISS", {})
            unit:AddNewModifier(unit, nil, "MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED", {})
            _G.SummonedZeus = true
        end)
    end
end
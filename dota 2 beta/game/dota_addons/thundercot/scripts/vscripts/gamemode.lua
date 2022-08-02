-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "2.0.16"

-- Selection library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')
-- filters.lua
require('filters')

require("util/shared")
require("util/other")
require("util/table")
require("util/debug")
require("util/string")
require("util/ability")
require("util/modifier")
require("util/item")
require("util/units")
require("util/playerresource")
require("util/math")
require("modules/dynamic_wearables/dynamic_wearables")
require("modules/neutrals/neutral_slot")

require("data/modifiers")
require("spawnunits")

require("modules/waves/main")
require("modules/effects/PlayerEffects")

LinkLuaModifier("modifier_evil_citadel", "modifiers/modifier_evil_citadel.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_limited_lives", "modifiers/modifier_limited_lives.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undying_grave_custom_resurrecting", "heroes/hero_undying/grave.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_target", "modifiers/modifier_dummy_target.lua", LUA_MODIFIER_MOTION_NONE)

-- Buffs and boons --
LinkLuaModifier("modifier_player_difficulty_buff_gold_50", "modifiers/modes/buffs/easy/modifier_player_difficulty_buff_gold_50.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_buff_heal_on_kill_25", "modifiers/modes/buffs/easy/modifier_player_difficulty_buff_heal_on_kill_25.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_buff_damage_reduction_50", "modifiers/modes/buffs/easy/modifier_player_difficulty_buff_damage_reduction_50.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_buff_armor_50", "modifiers/modes/buffs/easy/modifier_player_difficulty_buff_armor_50.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_buff_damage_25", "modifiers/modes/buffs/easy/modifier_player_difficulty_buff_damage_25.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_buff_bounty_rune_200", "modifiers/modes/buffs/easy/modifier_player_difficulty_buff_bounty_rune_200.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_player_difficulty_buff_bounty_rune_50", "modifiers/modes/buffs/normal/modifier_player_difficulty_buff_bounty_rune_50.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_buff_gold_10", "modifiers/modes/buffs/normal/modifier_player_difficulty_buff_gold_10.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_buff_heal_on_kill_10", "modifiers/modes/buffs/normal/modifier_player_difficulty_buff_heal_on_kill_10.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_enemy_difficulty_buff_death_explosion_10", "modifiers/modes/buffs/normal/modifier_enemy_difficulty_buff_death_explosion_10.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_extra_attack_10", "modifiers/modes/buffs/normal/modifier_enemy_difficulty_buff_extra_attack_10.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_hp_regen_pct_1", "modifiers/modes/buffs/normal/modifier_enemy_difficulty_buff_hp_regen_pct_1.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_player_difficulty_boon_reduced_healing_50", "modifiers/modes/buffs/hard/modifier_player_difficulty_boon_reduced_healing_50.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_health_drain_1", "modifiers/modes/buffs/hard/modifier_player_difficulty_boon_health_drain_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_misfire_30", "modifiers/modes/buffs/hard/modifier_player_difficulty_boon_misfire_30.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_blinded_30", "modifiers/modes/buffs/hard/modifier_player_difficulty_boon_blinded_30.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_enemy_difficulty_buff_death_explosion_15", "modifiers/modes/buffs/hard/modifier_enemy_difficulty_buff_death_explosion_15.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_hp_regen_pct_1_5", "modifiers/modes/buffs/hard/modifier_enemy_difficulty_buff_hp_regen_pct_1_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_petrify_10", "modifiers/modes/buffs/hard/modifier_enemy_difficulty_buff_petrify_10.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_attack_speed_missing_hp_50", "modifiers/modes/buffs/hard/modifier_enemy_difficulty_buff_attack_speed_missing_hp_50.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_leaky_1", "modifiers/modes/buffs/hard/modifier_player_difficulty_boon_leaky_1.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_player_difficulty_boon_reduced_healing_40", "modifiers/modes/buffs/unfair/modifier_player_difficulty_boon_reduced_healing_40.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_health_drain_5", "modifiers/modes/buffs/unfair/modifier_player_difficulty_boon_health_drain_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_random_speed_debuffs_30_60", "modifiers/modes/buffs/unfair/modifier_player_difficulty_boon_random_speed_debuffs_30_60.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_misfire_50", "modifiers/modes/buffs/unfair/modifier_player_difficulty_boon_misfire_50.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_ally_proximity_debuff_1", "modifiers/modes/buffs/unfair/modifier_player_difficulty_boon_ally_proximity_debuff_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_ally_movement_freeze_3", "modifiers/modes/buffs/unfair/modifier_player_difficulty_boon_ally_movement_freeze_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_leaky_2_5", "modifiers/modes/buffs/unfair/modifier_player_difficulty_boon_leaky_2_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_blinded_no_vision_50", "modifiers/modes/buffs/unfair/modifier_player_difficulty_boon_blinded_no_vision_50.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_enemy_difficulty_buff_death_explosion_20", "modifiers/modes/buffs/unfair/modifier_enemy_difficulty_buff_death_explosion_20.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_petrify_40", "modifiers/modes/buffs/unfair/modifier_enemy_difficulty_buff_petrify_40.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_attack_speed_missing_hp_80", "modifiers/modes/buffs/unfair/modifier_enemy_difficulty_buff_attack_speed_missing_hp_80.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_mana_burn_5", "modifiers/modes/buffs/unfair/modifier_enemy_difficulty_buff_mana_burn_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_wraith_5_20", "modifiers/modes/buffs/unfair/modifier_enemy_difficulty_buff_wraith_5_20.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_wraith_5_20_buff", "modifiers/modes/buffs/unfair/modifier_enemy_difficulty_buff_wraith_5_20.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_crit_chance_60", "modifiers/modes/buffs/unfair/modifier_enemy_difficulty_buff_crit_chance_60.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_player_difficulty_boon_reduced_healing_and_health_drain_5_75", "modifiers/modes/buffs/impossible/modifier_player_difficulty_boon_reduced_healing_and_health_drain_5_75.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_leaky_5", "modifiers/modes/buffs/impossible/modifier_player_difficulty_boon_leaky_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_weapon_destruction_30", "modifiers/modes/buffs/impossible/modifier_player_difficulty_boon_weapon_destruction_30.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_disarm_30", "modifiers/modes/buffs/impossible/modifier_player_difficulty_boon_disarm_30.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_hex_30", "modifiers/modes/buffs/impossible/modifier_player_difficulty_boon_hex_30.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_self_death_explosion_60", "modifiers/modes/buffs/impossible/modifier_player_difficulty_boon_self_death_explosion_60.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_magical_damage_40", "modifiers/modes/buffs/impossible/modifier_enemy_difficulty_buff_magical_damage_40.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_wraith_5_10", "modifiers/modes/buffs/impossible/modifier_enemy_difficulty_buff_wraith_5_10.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_death_explosion_30", "modifiers/modes/buffs/impossible/modifier_enemy_difficulty_buff_death_explosion_30.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_reverse_taunt_5", "modifiers/modes/buffs/impossible/modifier_enemy_difficulty_buff_reverse_taunt_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_petrify_60", "modifiers/modes/buffs/impossible/modifier_enemy_difficulty_buff_petrify_60.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_difficulty_buff_steal_damage_10", "modifiers/modes/buffs/impossible/modifier_enemy_difficulty_buff_steal_damage_10.lua", LUA_MODIFIER_MOTION_NONE)


--//--


--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function barebones:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache.")
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function barebones:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game.")
  
  -- Force Random a hero for every player that didnt pick a hero when time runs out
  local delay = HERO_SELECTION_TIME + HERO_SELECTION_PENALTY_TIME + STRATEGY_TIME - 0.1
  if ENABLE_BANNING_PHASE then
    delay = delay + BANNING_PHASE_TIME
  end
  Timers:CreateTimer(delay, function()
    for playerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
      if PlayerResource:IsValidPlayerID(playerID) then
        -- If this player still hasn't picked a hero, random one
        -- PlayerResource:IsConnected(index) is custom-made! Can be found in 'player_resource.lua' library
        if not PlayerResource:HasSelectedHero(playerID) and PlayerResource:IsConnected(playerID) and not PlayerResource:IsBroadcaster(playerID) then
          PlayerResource:GetPlayer(playerID):MakeRandomHeroSelection() -- this will cause an error if player is disconnected, that's why we check if player is connected
          PlayerResource:SetHasRandomed(playerID)
          PlayerResource:SetCanRepick(playerID, false)
          DebugPrint("[BAREBONES] Randomed a hero for a player number "..playerID)
        end
      end
    end
  end)

  if tablelength(KILL_VOTE_RESULT) <= 0 then
    KILL_VOTE_RESULT = {tostring(KILL_VOTE_DEFAULT)} 
  end

  local killCountToEnd = maxFreq(KILL_VOTE_RESULT, tablelength(KILL_VOTE_RESULT), KILL_VOTE_DEFAULT)
  KILL_VOTE_RESULT = killCountToEnd

  --

  if tablelength(WAVE_VOTE_RESULT) <= 0 then
    WAVE_VOTE_RESULT = {tostring(WAVE_VOTE_DEFAULT)} 
  end

  local waveVote = maxFreq(WAVE_VOTE_RESULT, tablelength(WAVE_VOTE_RESULT), WAVE_VOTE_DEFAULT)
  WAVE_VOTE_RESULT = waveVote

  local effectVote = maxFreq(EFFECT_VOTE_RESULT, tablelength(EFFECT_VOTE_RESULT), EFFECT_VOTE_DEFAULT)
  EFFECT_VOTE_RESULT = effectVote

  if WAVE_VOTE_RESULT == "DISABLE" then
    CustomGameEventManager:Send_ServerToAllClients("waves_disable", {})
  end

  ---
  local enableEffects = EFFECT_VOTE_RESULT:upper() == "ENABLE"
  local t = {}
  local mode = KILL_VOTE_RESULT:upper()
  local difficultyChatTablePlayers = {}
  local difficultyChatTableEnemies = {}


  if enableEffects then

    if mode == "EASY" then
      t = PLAYER_EASY_BUFFS
      for i = 1, 2, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyEasyBuffs, t[index])
        table.remove(t, index)
      end
      difficultyChatTablePlayers = _G.DifficultyEasyBuffs
    end

    if mode == "NORMAL" then
      t = PLAYER_NORMAL_BUFFS
      for i = 1, 1, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyNormalPlayerBuffs, t[index])
        table.remove(t, index)
      end

      t = ENEMY_NORMAL_BUFFS
      for i = 1, 1, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyNormalEnemyBuffs, t[index])
        table.remove(t, index)
      end

      difficultyChatTablePlayers = _G.DifficultyNormalPlayerBuffs
      difficultyChatTableEnemies = _G.DifficultyNormalEnemyBuffs
    end

    if mode == "HARD" then
      t = PLAYER_ALL_BOONS
      for i = 1, 1, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyHardPlayerBoons, t[index])
        table.remove(t, index)
      end

      t = ENEMY_ALL_BUFFS
      for i = 1, 2, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyHardEnemyBuffs, t[index])
        table.remove(t, index)
      end

      difficultyChatTablePlayers = _G.DifficultyHardPlayerBoons
      difficultyChatTableEnemies = _G.DifficultyHardEnemyBuffs
    end

    if mode == "UNFAIR" then
      t = PLAYER_ALL_BOONS
      for i = 1, 2, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyUnfairPlayerBoons, t[index])
        table.remove(t, index)
      end

      t = ENEMY_ALL_BUFFS
      for i = 1, 2, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyUnfairEnemyBuffs, t[index])
        table.remove(t, index)
      end

      difficultyChatTablePlayers = _G.DifficultyUnfairPlayerBoons
      difficultyChatTableEnemies = _G.DifficultyUnfairEnemyBuffs
    end

    if mode == "IMPOSSIBLE" then
      t = PLAYER_ALL_BOONS
      for i = 1, 2, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyImpossiblePlayerBoons, t[index])
        table.remove(t, index)
      end

      t = ENEMY_ALL_BUFFS
      for i = 1, 3, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyImpossibleEnemyBuffs, t[index])
        table.remove(t, index)
      end

      difficultyChatTablePlayers = _G.DifficultyImpossiblePlayerBoons
      difficultyChatTableEnemies = _G.DifficultyImpossibleEnemyBuffs
    end

    if mode == "HELL" then
      t = PLAYER_ALL_BOONS
      for i = 1, 3, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyHellPlayerBoons, t[index])
        table.remove(t, index)
      end

      t = ENEMY_ALL_BUFFS
      for i = 1, 4, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyHellEnemyBuffs, t[index])
        table.remove(t, index)
      end

      difficultyChatTablePlayers = _G.DifficultyHellPlayerBoons
      difficultyChatTableEnemies = _G.DifficultyHellEnemyBuffs
    end

    if mode == "HARDCORE" then
      t = PLAYER_ALL_BOONS
      for i = 1, 4, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyHardcorePlayerBoons, t[index])
        table.remove(t, index)
      end

      t = ENEMY_ALL_BUFFS
      for i = 1, 5, 1 do
        local index = RandomInt(1, #t)
        table.insert(_G.DifficultyHardcoreEnemyBuffs, t[index])
        table.remove(t, index)
      end

      difficultyChatTablePlayers = _G.DifficultyHardcorePlayerBoons
      difficultyChatTableEnemies = _G.DifficultyHardcoreEnemyBuffs
    end

  end

  -- Print Chat Info --
  Timers:CreateTimer(1.0, function()
    if KILL_VOTE_RESULT:upper() == "EASY" or KILL_VOTE_RESULT:upper() == "NORMAL" then
      GameRules:SendCustomMessage("<font color='yellow'>=== DIFFICULTY [<b color='lightgreen'>"..KILL_VOTE_RESULT:upper().."</b>] ===</font>", 0, 0)
    else
      GameRules:SendCustomMessage("<font color='yellow'>=== DIFFICULTY [<b color='red'>"..KILL_VOTE_RESULT:upper().."</b>] ===</font>", 0, 0)
    end

    if WAVE_VOTE_RESULT == "ENABLE" then
      GameRules:SendCustomMessage("<font color='yellow'>=== WAVES [<b color='lightgreen'>ENABLED</b>] ===</font>", 0, 0)
    else
      GameRules:SendCustomMessage("<font color='yellow'>=== WAVES [<b color='red'>DISABLED</b>] ===</font>", 0, 0)
    end

    if enableEffects then
      GameRules:SendCustomMessageToTeam("<font color='yellow'>=== PLAYER EFFECTS THIS GAME ===</font>", DOTA_TEAM_GOODGUYS, 0, 0)
      for _,temp in ipairs(difficultyChatTablePlayers) do
        GameRules:SendCustomMessageToTeam("#DOTA_Tooltip_"..temp, DOTA_TEAM_GOODGUYS, 0, 0)
      end

      GameRules:SendCustomMessageToTeam("<font color='yellow'>=== ENEMY CREEP EFFECTS THIS GAME ===</font>", DOTA_TEAM_GOODGUYS, 0, 0)
      for _,temp in ipairs(difficultyChatTableEnemies) do
        GameRules:SendCustomMessageToTeam("#DOTA_Tooltip_"..temp, DOTA_TEAM_GOODGUYS, 0, 0)
      end
    else
      GameRules:SendCustomMessage("<font color='yellow'>=== MODIFIERS [<b color='red'>DISABLED</b>] ===</font>", 0, 0)
    end
  end)
  --//--
end

function barebones:OnFirstPlayerLoaded()
  CustomGameEventManager:RegisterListener("killvote", function(userId, event)
    table.insert(KILL_VOTE_RESULT, tostring(event.option):upper())
  end)

  CustomGameEventManager:RegisterListener("wavevote", function(userId, event)
    table.insert(WAVE_VOTE_RESULT, tostring(event.option):upper())
  end)

  CustomGameEventManager:RegisterListener("effectvote", function(userId, event)
    table.insert(EFFECT_VOTE_RESULT, tostring(event.option):upper())
  end)

  CustomGameEventManager:RegisterListener("auto_pickup", function(userId, event)
    local state = tostring(event.option)
    local enabled = false

    if state == "on" then
      enabled = true
    else
      enabled = false
    end

    _G.autoPickup[event.playerID] = enabled
  end)

  CustomGameEventManager:RegisterListener("ability_selection_change", function(userId, event)
    local ability = event.ability
    local player = EntIndexToHScript(event.user)

    local abilitySelection = {}

    -- Makes sure the ability is valid (not scepter, shard, or linked) and 
    -- that it's not an ability the player already has.
    --todo: find a way to check if it's shrd or aghs and then remove it from the table...
    function isAbilityValid(name)
      for i=0, player:GetAbilityCount()-1 do
          local abil = player:GetAbilityByIndex(i)
          if abil ~= nil then
            if abil:GetAbilityName() == name then 
              return false
            end
          end
      end

      return true
    end

    -- Makes sure the player can't get shown an ability they're not supposed to get
    function isAbilityBanned(name)
      for _,ban in ipairs(BOOK_ABILITY_SELECTION_EXCEPTIONS) do
        if ban == name then return true end
      end

      return false
    end

    -- Remove all non-valid abilities from the selection list
    for i = 1, #BOOK_ABILITY_SELECTION, 1 do 
      if isAbilityValid(BOOK_ABILITY_SELECTION[i]) and not isAbilityBanned(BOOK_ABILITY_SELECTION[i]) then
        table.insert(abilitySelection, BOOK_ABILITY_SELECTION[i])
      end
    end

    -- Random the selection out of the available abilities
    local randomSelection = {}

    --_G.PlayerBookRandomAbilities[player:GetPlayerID()] = nil

    for i = 1, 4, 1 do
      table.insert(randomSelection, abilitySelection[RandomInt(1, #abilitySelection)])
    end


    _G.PlayerBookRandomAbilities[player:GetPlayerID()] = randomSelection

    --todo: filterto make sure you can't get abilities you already have
    --also: make sure you can't get excluded abilities (make new table to define what those are)
    --remove the abilities the player has from this temp table (including new ones they get with the books)
    --random the 4 abilities in lua and send the names to the client. and when the client sends back the picks, validate 
    --them to make sure its an ability that's one of the 4 the server sent (use global user variable?)

    CustomNetTables:SetTableValue("ability_selection_open_replace", "game_info", { 
      oldAbility = ability, 
      userEntIndex = event.user, 
      abilities = abilitySelection, 
      selection = randomSelection 
    })
  end)

  CustomGameEventManager:RegisterListener("ability_selection_change_final", function(userId, event)
    local oldAbility = event.oldAbility
    local ability = event.ability
    local player = EntIndexToHScript(event.user)

    --todo:
    --make sure abilities you replace aren't aghs or shard.
    --make sure the new abilities you can choose from aren't aghs and shard, or useless stuff like icarus dive cancel.

    function isSelectionValid(name)
      if _G.PlayerBookRandomAbilities[player:GetPlayerID()] == nil then return false end

      for i = 1, #_G.PlayerBookRandomAbilities[player:GetPlayerID()], 1 do
        local valid = _G.PlayerBookRandomAbilities[player:GetPlayerID()][i]
        if valid == name then return true end
      end

      return false
    end

    if not isSelectionValid(ability) then DisplayError(player:GetPlayerID(), "Invalid Ability Selected") return end

    player:AddAbility(ability)
    player:SwapAbilities(oldAbility, ability, false, true)
    player:RemoveAbility(oldAbility)

    if _G.PlayerStoredAbilities[player:GetUnitName()] == nil then
      _G.PlayerStoredAbilities[player:GetUnitName()] = {}
    end

    table.insert(_G.PlayerStoredAbilities[player:GetUnitName()], ability)

    for i = 1, #_G.PlayerStoredAbilities[player:GetUnitName()], 1 do
      if _G.PlayerStoredAbilities[player:GetUnitName()][i] == oldAbility then
        table.remove(_G.PlayerStoredAbilities[player:GetUnitName()], i)
      end
    end
  end)

  CustomGameEventManager:RegisterListener("ability_selection_swap_position_final", function(userId, event)
    local ability = event.ability
    local player = EntIndexToHScript(event.user)

    CustomNetTables:SetTableValue("ability_selection_swap_position_replace", "game_info", { oldAbility = ability, userEntIndex = event.user })
  end)

  CustomGameEventManager:RegisterListener("ability_selection_swap_position_final_complete", function(userId, event)
    local oldAbility = event.oldAbility
    local ability = event.ability
    local player = EntIndexToHScript(event.user)

    --todo:
    --make sure abilities you replace aren't aghs or shard.
    --make sure the new abilities you can choose from aren't aghs and shard, or useless stuff like icarus dive cancel.

    player:SwapAbilities(oldAbility, ability, true, true)
  end)
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function barebones:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun.")

  Timers:CreateTimer(2.0, function() 
    CustomGameEventManager:Send_ServerToAllClients("duel_timer_changed", {isDuelActive = KILL_VOTE_RESULT:upper() })

    Timers:CreateTimer(1.0, function()
      SpawnAllUnits()
    end)
  end)

  if GetMapName() == "tcotrpg" then
    local evilCitadel = Entities:FindByName(nil, "evil_citadel")
    Timers:CreateTimer(1.0, function()
      local evilTowers = Entities:FindAllByName("dota_badguys_tower1_bot")
      if #evilTowers < 1 then 
        evilCitadel:RemoveModifierByName("modifier_invulnerable")
        return
      end

      return 1.0
    end)

    evilCitadel:AddNewModifier(evilCitadel, nil, "modifier_evil_citadel", {})
    if WAVE_VOTE_RESULT == "ENABLE" and GetMapName() == "tcotrpg" then
      _G.bWavesEnabled = true
      Timers:CreateTimer(60.0, function()
        InitiateWaves()
      end)
    else
      _G.bWavesEnabled = false
      CustomGameEventManager:Send_ServerToAllClients("waves_disable", {})
      --CustomNetTables:SetTableValue("waves_disable", "game_info", { enabled = false })
    end
  end
  --

  -- If the day/night is not changed at 00:00, uncomment the following line:
  GameRules:SetTimeOfDay(0.75)
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function barebones:InitGameMode()
  DebugPrint("[BAREBONES] Starting to load Game Rules.")

  -- Setup rules
  GameRules:SetSameHeroSelectionEnabled(ALLOW_SAME_HERO_SELECTION)
  GameRules:SetUseUniversalShopMode(UNIVERSAL_SHOP_MODE)
  GameRules:SetHeroRespawnEnabled(ENABLE_HERO_RESPAWN)

  GameRules:SetHeroSelectionTime(HERO_SELECTION_TIME) -- THIS IS IGNORED when "EnablePickRules" is "1" in 'addoninfo.txt' !
  GameRules:SetHeroSelectPenaltyTime(HERO_SELECTION_PENALTY_TIME)

  GameRules:SetPreGameTime(PRE_GAME_TIME)
  GameRules:SetPostGameTime(POST_GAME_TIME)
  GameRules:SetShowcaseTime(SHOWCASE_TIME)
  GameRules:SetStrategyTime(STRATEGY_TIME)

  GameRules:SetTreeRegrowTime(TREE_REGROW_TIME)

  if USE_CUSTOM_HERO_LEVELS then
    GameRules:SetUseCustomHeroXPValues(true)
  end

  --GameRules:SetGoldPerTick(GOLD_PER_TICK) -- Doesn't work 24.2.2020
  --GameRules:SetGoldTickTime(GOLD_TICK_TIME) -- Doesn't work 24.2.2020
  GameRules:SetStartingGold(NORMAL_START_GOLD)

  if USE_CUSTOM_HERO_GOLD_BOUNTY then
    GameRules:SetUseBaseGoldBountyOnHeroes(false) -- if true Heroes will use their default base gold bounty which is similar to creep gold bounty, rather than DOTA specific formulas
  end

  GameRules:SetHeroMinimapIconScale(MINIMAP_ICON_SIZE)
  GameRules:SetCreepMinimapIconScale(MINIMAP_CREEP_ICON_SIZE)
  GameRules:SetRuneMinimapIconScale(MINIMAP_RUNE_ICON_SIZE)
  GameRules:SetFirstBloodActive(ENABLE_FIRST_BLOOD)
  GameRules:SetHideKillMessageHeaders(HIDE_KILL_BANNERS)
  GameRules:LockCustomGameSetupTeamAssignment(LOCK_TEAMS)

  -- This is multi-team configuration stuff
  if USE_AUTOMATIC_PLAYERS_PER_TEAM then
    local num = math.floor(10/MAX_NUMBER_OF_TEAMS)
    local count = 0
    for team, number in pairs(TEAM_COLORS) do
      if count >= MAX_NUMBER_OF_TEAMS then
        GameRules:SetCustomGameTeamMaxPlayers(team, 0)
      else
        GameRules:SetCustomGameTeamMaxPlayers(team, num)
      end
      count = count + 1
    end
  else
    local count = 0
    for team, number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
      if count >= MAX_NUMBER_OF_TEAMS then
        GameRules:SetCustomGameTeamMaxPlayers(team, 0)
      else
        GameRules:SetCustomGameTeamMaxPlayers(team, number)
      end
      count = count + 1
    end
  end

  if USE_CUSTOM_TEAM_COLORS then
    for team, color in pairs(TEAM_COLORS) do
      SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
    end
  end

  DebugPrint("[BAREBONES] Done with setting Game Rules.")

  -- Event Hooks / Listeners
  DebugPrint("[BAREBONES] Setting Event Hooks / Listeners.")
  ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(barebones, 'OnPlayerLevelUp'), self)
  ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(barebones, 'OnPlayerLearnedAbility'), self)
  ListenToGameEvent('entity_killed', Dynamic_Wrap(barebones, 'OnEntityKilled'), self)
  ListenToGameEvent('player_connect_full', Dynamic_Wrap(barebones, 'OnConnectFull'), self)
  ListenToGameEvent('player_disconnect', Dynamic_Wrap(barebones, 'OnDisconnect'), self)
  ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(barebones, 'OnItemPickedUp'), self)
  ListenToGameEvent('last_hit', Dynamic_Wrap(barebones, 'OnLastHit'), self)
  ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(barebones, 'OnRuneActivated'), self)
  ListenToGameEvent('tree_cut', Dynamic_Wrap(barebones, 'OnTreeCut'), self)
  --ListenToGameEvent("dota_player_killed", Dynamic_Wrap(barebones, 'OnPlayerDeath'), self)
  ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(barebones, 'OnAbilityUsed'), self)
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(barebones, 'OnGameRulesStateChange'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(barebones, 'OnNPCSpawned'), self)
  ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(barebones, 'OnPlayerPickHero'), self)
  ListenToGameEvent("player_reconnected", Dynamic_Wrap(barebones, 'OnPlayerReconnect'), self)
  ListenToGameEvent("player_chat", Dynamic_Wrap(barebones, 'OnPlayerChat'), self)

  ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(barebones, 'OnTowerKill'), self)
  ListenToGameEvent("dota_player_selected_custom_team", Dynamic_Wrap(barebones, 'OnPlayerSelectedCustomTeam'), self)
  ListenToGameEvent("dota_npc_goal_reached", Dynamic_Wrap(barebones, 'OnNPCGoalReached'), self)
  ListenToGameEvent("dota_item_combined", Dynamic_Wrap(barebones, 'OnItemCombined'), self)

  -- Change random seed for math.random function
  local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
  math.randomseed(tonumber(timeTxt))

  DebugPrint("[BAREBONES] Setting Filters.")

  local gamemode = GameRules:GetGameModeEntity()

  -- Setting the Order filter 
  gamemode:SetExecuteOrderFilter(Dynamic_Wrap(barebones, "OrderFilter"), self)

  -- Setting the Damage filter
  gamemode:SetDamageFilter(Dynamic_Wrap(barebones, "DamageFilter"), self)

  -- Setting the Modifier filter
  gamemode:SetModifierGainedFilter(Dynamic_Wrap(barebones, "ModifierFilter"), self)

  -- Setting the Experience filter
  gamemode:SetModifyExperienceFilter(Dynamic_Wrap(barebones, "ExperienceFilter"), self)

  -- Setting the Tracking Projectile filter
  gamemode:SetTrackingProjectileFilter(Dynamic_Wrap(barebones, "ProjectileFilter"), self)

  -- Setting the bounty rune pickup filter
  gamemode:SetBountyRunePickupFilter(Dynamic_Wrap(barebones, "BountyRuneFilter"), self)

  -- Setting the Healing filter
  gamemode:SetHealingFilter(Dynamic_Wrap(barebones, "HealingFilter"), self)

  gamemode:SetNeutralStashEnabled(false)
  gamemode:SetAllowNeutralItemDrops(false)
  gamemode:SetCustomBackpackSwapCooldown(0)
  gamemode:SetNeutralItemHideUndiscoveredEnabled(true)

  -- Setting the Gold Filter
  gamemode:SetModifyGoldFilter(Dynamic_Wrap(barebones, "GoldFilter"), self)

  -- Setting the Inventory filter
  gamemode:SetItemAddedToInventoryFilter(Dynamic_Wrap(barebones, "InventoryFilter"), self)



  DebugPrint("[BAREBONES] Done with setting Filters.")

  -- Global Lua Modifiers
  LinkLuaModifier("modifier_custom_invulnerable", "modifiers/modifier_custom_invulnerable", LUA_MODIFIER_MOTION_NONE)

  print("[BAREBONES] initialized.")
  DebugPrint("[BAREBONES] Done loading the game mode!\n\n")
  
  -- Increase/decrease maximum item limit per hero
  Convars:SetInt('dota_max_physical_items_purchase_limit', 64)

  -- stuff --
end

local totalDeadCount = 0

function barebones:OnEntityKilled(keys)
  local killed_entity_index = keys.entindex_killed
  local attacker_entity_index = keys.entindex_attacker
  local inflictor_index = keys.entindex_inflictor -- it can be nil if not killed by an item/ability

  -- Find the entity that was killed
  local killed_unit
  if killed_entity_index then
    killed_unit = EntIndexToHScript(killed_entity_index)
  end

  -- Find the entity (killer) that killed the entity mentioned above
  local killer_unit
  if attacker_entity_index then
    killer_unit = EntIndexToHScript(attacker_entity_index)
  end

  if killed_unit == nil or killer_unit == nil then
    -- Don't continue if killer or killed entity doesn't exist
    return
  end
  -- Find the ability/item used to kill, or nil if not killed by an item/ability
  local killing_ability
  if inflictor_index then
    killing_ability = EntIndexToHScript(inflictor_index)
  end

  -- For Meepo clones, find the original
  if killed_unit:IsClone() then
    if killed_unit:GetCloneSource() then
      killed_unit = killed_unit:GetCloneSource()
    end
  end

  if killed_unit ~= nil then
    if IsCreepTCOTRPG(killed_unit) and killer_unit:IsRealHero() then
      local selectionTable = NEUTRAL_ITEM_DROP_TABLE_COMMON
      local selectionPool = {}
      local minutesPassedSinceGameStart = math.floor(GameRules:GetGameTime() / 60)
      local rand = RandomFloat(0.0, 1.0)

      -- Past 10 minutes and 75% chance
      if minutesPassedSinceGameStart >= 5 then
        for i = 1, #NEUTRAL_ITEM_DROP_TABLE_UNCOMMON, 1 do
          table.insert(selectionPool, NEUTRAL_ITEM_DROP_TABLE_UNCOMMON[i])
        end
      end

      if minutesPassedSinceGameStart >= 15 then
        for i = 1, #NEUTRAL_ITEM_DROP_TABLE_RARE, 1 do
          table.insert(selectionPool, NEUTRAL_ITEM_DROP_TABLE_RARE[i])
        end
      end

      if minutesPassedSinceGameStart >= 30 then
        for i = 1, #NEUTRAL_ITEM_DROP_TABLE_LEGENDARY, 1 do
          table.insert(selectionPool, NEUTRAL_ITEM_DROP_TABLE_LEGENDARY[i])
        end
      end

      if (RandomFloat(0.0, 100.0) <= 1) and not _G.PlayerNeutralDropCooldowns[killer_unit:GetPlayerID()] then
        _G.PlayerNeutralDropCooldowns[killer_unit:GetPlayerID()] = true
        local drop = DropNeutralItemAtPositionForHero(selectionPool[RandomInt(1, #selectionPool)], killed_unit:GetAbsOrigin(), killed_unit, -1, true)
        Timers:CreateTimer(120, function()
          _G.PlayerNeutralDropCooldowns[killer_unit:GetPlayerID()] = false
        end)
      end
      -- Midas --
      local midas = nil
      local midas3 = false
      if killer_unit:FindItemInInventory("item_hand_of_midas3") ~= nil then
        midas = killer_unit:FindItemInInventory("item_hand_of_midas3")
        midas3 = true
      elseif killer_unit:FindItemInInventory("item_hand_of_midas2") ~= nil then
        midas = killer_unit:FindItemInInventory("item_hand_of_midas2")
      end

      if midas ~= nil and not midas:IsInBackpack() then
        local killGold = midas:GetSpecialValueFor("gold_per_kill")
        if midas3 then
          killGold = killGold + (killed_unit:GetMaximumGoldBounty() * (midas:GetSpecialValueFor("gold_pct")/100))
        end

        killer_unit:ModifyGold(killGold, true, DOTA_ModifyGold_CreepKill) 

        local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas_b.vpcf", PATTACH_OVERHEAD_FOLLOW, killed_unit)   
        ParticleManager:SetParticleControlEnt(midas_particle, 1, killed_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", killed_unit:GetAbsOrigin(), false)
        ParticleManager:ReleaseParticleIndex(midas_particle)
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, killed_unit, killGold, nil)
      end
    end

    if (KILL_VOTE_RESULT:upper() == "IMPOSSIBLE" or KILL_VOTE_RESULT:upper() == "HELL" or KILL_VOTE_RESULT:upper() == "HARDCORE") and killed_unit:IsRealHero() and not killed_unit:IsReincarnating() and not killed_unit:WillReincarnate() then
      local mod = killed_unit:FindModifierByNameAndCaster("modifier_limited_lives", killed_unit)
      if mod ~= nil then
        mod:DecrementStackCount()

        if mod:GetStackCount() <= 0 then
          killed_unit:RemoveModifierByNameAndCaster("modifier_limited_lives", killed_unit)
          killed_unit:SetRespawnsDisabled(true)
          return false
        end
      elseif mod == nil then
        --killed_unit:SetRespawnsDisabled(true)
        --return false
      end
    end
  end

  -- This is for the default respawn times --
  if killed_unit:IsRealHero() then
    if not killed_unit:IsReincarnating() and not killed_unit:WillReincarnate() then
      killed_unit:SetTimeUntilRespawn(10)
    end
  end
end


function barebones:OnItemCombined(event)
  --[[
  local purchasableLostItems = {
    "item_kings_guard_7",
    "item_mercure7",
    "item_rebels_sword",
    "item_octarine_core6",
    "item_trident_custom_6",
    "item_veil_of_discord6",
    "item_last_soul",
  }

  for _,lostItem in ipairs(purchasableLostItems) do
    if event.itemname == lostItem then
      if _G.lostItems[event.PlayerID] >= 1 then
        DisplayError(event.PlayerID, "#one_lost_soul_item_error")
        return false
      end

      _G.lostItems[event.PlayerID] = 1
    end
  end
  --]]
end

function barebones:InventoryFilter(event)
  if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME or GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
    return false
  end

  if not event.item_entindex_const then return end
  if not event.inventory_parent_entindex_const then return end

  local item = EntIndexToHScript(event.item_entindex_const)
  if not item or item:IsNull() then return true end

  local itemName = item:GetAbilityName()
  
  local player = EntIndexToHScript(event.inventory_parent_entindex_const)
  if not player then return true end
  if player:IsNull() then return end

  if itemName == "item_travel_boots_3" then
    event.suggested_slot = DOTA_ITEM_TP_SCROLL
    return true
  end

  local noPurchaseTimeItems = {
    "item_flicker",
    "item_ninja_gear",
    "item_the_leveller",
    "item_minotaur_horn",
    "item_spy_gadget",
    "item_trickster_cloak",
    "item_stormcrafter",
    "item_penta_edged_sword",
    "item_ascetic_cap",
    "item_illusionsts_cape",
    "item_heavy_blade",
    "item_quickening_charm",
    "item_spider_legs",
    "item_pupils_gift",
    "item_imp_claw",
    "item_paladin_sword",
    "item_orb_of_destruction",
    "item_titan_sliver",
    "item_mind_breaker",
    "item_enchanted_quiver",
    "item_elven_tunic",
    "item_ceremonial_robe",
    "item_ring_of_aquila",
    "item_psychic_headband",
    "item_black_powder_bag",
    "item_vambrace",
    "item_grove_bow",
    "item_misericorde",
    "item_quicksilver_amulet",
    "item_essence_ring",
    "item_nether_shawl",
    "item_bullwhip",
    "item_keen_optic",
    "item_ironwood_tree",
    "item_ocean_heart",
    "item_broom_handle",
    "item_faded_broach",
    "item_arcane_ring",
    "item_chipped_vest",
    "item_possessed_mask",
    "item_mysterious_hat",
    "item_philosophers_stone",
    "item_unstable_wand",
    "item_pogo_stick",
    "item_paintball",
    "item_royal_jelly",
    "item_force_boots",
    "item_seer_stone",
    "item_apex",
    "item_fallen_sky",
    "item_pirate_hat",
    "item_force_field",
    "item_vengeances_shadow",
    "item_timeless_relic",
    "item_spell_prism",
    "item_charged_essence"
  }

  for _,npItem in ipairs(noPurchaseTimeItems) do
    if item:GetAbilityName() == npItem then
      item:SetPurchaseTime(0)
      return true
    end
  end

  if NeutralSlot:NeedToNeutralSlot( item:GetName() ) and not player:IsCourier() then
    local slotIndex = NeutralSlot:GetSlotIndex()
    local itemInSlot = player:GetItemInSlot(slotIndex)

    if not itemInSlot then
      -- just practical heuristic, when hero take item from another unit/from ground event.item_parent_entindex_const != event.inventory_parent_entindex_const
      -- never ask me about this dirty hack.
      local isStash = event.item_parent_entindex_const == event.inventory_parent_entindex_const

      if not isStash or player:IsInRangeOfShop(DOTA_SHOP_HOME, true) then
        event.suggested_slot = NeutralSlot:GetSlotIndex()
      end
    end
  end

  if item.ForceShareable then
    item:SetPurchaser( player )
  end

  if string.find(item:GetName(), "_soul") and player:IsRealHero() and not IsBossTCOTRPG(player) then
  end

  --[[
  local purchasableLostItems = {
    "item_kings_guard_7",
    "item_mercure7",
    "item_rebels_sword",
    "item_octarine_core6",
    "item_trident_custom_6",
    "item_veil_of_discord6",
    "item_last_soul"
  }

  local purchasableLostItemsCourier = {
    "item_kings_guard_7",
    "item_mercure7",
    "item_veil_of_discord6",
    "item_recipe_veil_of_discord6",
    "item_trident_custom_6",
    "item_recipe_trident_custom_6",
    "item_recipe_kings_guard_7",
    "item_recipe_rebels_sword",
    "item_recipe_mercure7",
    "item_rebels_sword",
    "item_octarine_core6",
    "item_recipe_octarine_core6",
    "item_last_soul"
  }

  if not event.item_entindex_const then return end
  if not event.inventory_parent_entindex_const then return end

  local item = EntIndexToHScript(event.item_entindex_const)
  if not item or item:IsNull() then return true end

  local itemName = item:GetAbilityName()
  
  local player = EntIndexToHScript(event.inventory_parent_entindex_const)
  if not player then return true end
  if player:IsNull() then return end
  if IsBossTCOTRPG(player) then return true end
  if player:IsCourier() then
    for _,lostItem in ipairs(purchasableLostItemsCourier) do
    if itemName == lostItem then
      DisplayError(player:GetOwner():GetPlayerID(), "#lost_soul_courier")
      return false
      end
    end

    return true
  end



  if string.find(itemName, "recipe") then
    if (itemName == "item_recipe_veil_of_discord6" and player:FindItemInInventory("item_veil_of_discord5") ~= nil  and player:FindItemInInventory("item_last_soul") ~= nil) or (itemName == "item_recipe_trident_custom_6" and player:FindItemInInventory("item_trident_custom_5") ~= nil  and player:FindItemInInventory("item_last_soul") ~= nil) or (itemName == "item_recipe_kings_guard_7" and player:FindItemInInventory("item_recipe_kings_guard_6") ~= nil  and player:FindItemInInventory("item_last_soul") ~= nil) or (itemName == "item_recipe_mercure7" and player:FindItemInInventory("item_recipe_mercure6") ~= nil  and player:FindItemInInventory("item_last_soul") ~= nil) or (itemName == "item_recipe_rebels_sword" and player:FindItemInInventory("item_desolator6") ~= nil and player:FindItemInInventory("item_last_soul") ~= nil) or (itemName == "item_recipe_octarine_core6" and player:FindItemInInventory("item_octarine_core4") ~= nil and player:FindItemInInventory("item_last_soul") ~= nil) then
      itemName = string.gsub(itemName, "recipe_", "")
    end
  end

  if (itemName == "item_last_soul" and _G.lostItems[player:GetPlayerID()] >= 1) or (itemName == "item_last_soul" and player:FindItemInInventory("item_last_soul") ~= nil) then
    DisplayError(player:GetPlayerID(), "#one_lost_soul_item_error")
    return false
  end

  for _,lostItem in ipairs(purchasableLostItems) do
    if itemName == lostItem then
      if _G.lostItems[player:GetPlayerID()] >= 1 then
        DisplayError(player:GetPlayerID(), "#one_lost_soul_item_error")
        return false
      end

      _G.lostItems[player:GetPlayerID()] = 1
      return true
    end
  end
  --]]

  return true
end

-- A player picked or randomed a hero, it actually happens on spawn (this is sometimes happening before OnHeroInGame).
function barebones:OnPlayerPickHero(keys)
  DebugPrint("[BAREBONES] OnPlayerPickHero event")
  SendToConsole("dota_hud_healthbars 1")
  --PrintTable(keys)

  local hero_name = keys.hero
  local hero_entity
  if keys.heroindex then
    hero_entity = EntIndexToHScript(keys.heroindex)
  end
  local player
  if keys.player then
    player = EntIndexToHScript(keys.player)
  end

  Timers:CreateTimer(0.5, function()
    if not hero_entity then
      return
    end
    local playerID = hero_entity:GetPlayerID() -- or player:GetPlayerID() if player is not disconnected
    if PlayerResource:IsFakeClient(playerID) then
      -- This is happening only for bots when they spawn for the first time or if they use custom hero-create spells (Custom Illusion spells)
    else
      if not PlayerResource.PlayerData[playerID] and PlayerResource:IsValidPlayerID(playerID) then
        PlayerResource:InitPlayerDataForID(playerID)
      end
      if PlayerResource.PlayerData[playerID].already_assigned_hero == true then
        -- This is happening only when players create new heroes or replacing heroes
        DebugPrint("[BAREBONES] OnPlayerPickHero - Player with playerID "..playerID.." got another hero: "..hero_entity:GetUnitName())
      else
        PlayerResource:AssignHero(playerID, hero_entity)
        PlayerResource.PlayerData[playerID].already_assigned_hero = true
      end
    end
  end)
end

function barebones:HealingFilter(event)
  if not IsServer() then return end

  local target = EntIndexToHScript(event.entindex_target_const)

  if event.heal < 0 or event.heal > INT_MAX_LIMIT then
    --print("Limit heal out of bonds at: ", event.heal)
    event.heal = target:GetMaxHealth()
  end

  if target:GetUnitName() == "npc_dota_hero_huskar" then
    local mayhem = target:FindAbilityByName("huskar_mayhem_custom")
    if mayhem ~= nil and mayhem:GetLevel() > 0 then
      local threshold = mayhem:GetSpecialValueFor("max_hp_threshold")
      local forcedHeal = event.heal * (threshold / 100) 
      local maxAllowedHealth = target:GetMaxHealth() * (threshold / 100)
      local expectedHealing = target:GetHealth() + forcedHeal

      if expectedHealing > maxAllowedHealth then
        if target:IsAlive() then
          local modifiedHealth = target:GetHealth() + (expectedHealing - (expectedHealing - maxAllowedHealth))
          if modifiedHealth > maxAllowedHealth then
            modifiedHealth = maxAllowedHealth
          end
          target:ModifyHealth(modifiedHealth, nil, false, 0)
        end

        return false
      end

      event.heal = forcedHeal
    end
  end

  if target:HasModifier("modifier_player_difficulty_boon_reduced_healing_50") then
    event.heal = event.heal * 0.5
  end

  if target:HasModifier("modifier_player_difficulty_boon_reduced_healing_40") then
    event.heal = event.heal * 0.60
  end

  if target:HasModifier("modifier_player_difficulty_boon_reduced_healing_and_health_drain_5_75") then
    event.heal = event.heal * 0.25
  end

  return true
end

function barebones:BountyRuneFilter(keys)
  if not IsServer() then return end
  
  local gameTime = math.floor(GameRules:GetGameTime() / 60)

  local mode = KILL_VOTE_RESULT:upper()
  local bonus = 0
  if mode == "EASY" then
    bonus = 2.0
  elseif mode == "NORMAL" then
    bonus = 1.0
  elseif mode == "HARD" then
    bonus = 0.8
  elseif mode == "UNFAIR" then
    bonus = 0.4
  elseif mode == "IMPOSSIBLE" then
    bonus = 0.2
  elseif mode == "HELL" then
    bonus = 0.1
  elseif mode == "HARDCORE" then
    bonus = 0.05
  end

  keys.gold_bounty = 100 + ((25*bonus) * (gameTime / 2))
  keys.xp_bounty = 750 + ((60*bonus) * (gameTime / 2))

  local player = PlayerResource:GetPlayer(keys.player_id_const):GetAssignedHero()
  if player:HasModifier("modifier_player_difficulty_buff_bounty_rune_200") then
    keys.gold_bounty = keys.gold_bounty * 2
    keys.xp_bounty = keys.xp_bounty * 2
  end

  -- Difficulty scaling --
  local mode = KILL_VOTE_RESULT:upper()
  local multiplierBounty = 0

  if mode == "EASY" then
    multiplierBounty = 2.0
  elseif mode == "NORMAL" then
    multiplierBounty = 1.0
  elseif mode == "HARD" then
    multiplierBounty = 1.0
  elseif mode == "UNFAIR" then
    multiplierBounty = 1.0
  elseif mode == "IMPOSSIBLE" then
    multiplierBounty = 0.75
  elseif mode == "HELL" then
    multiplierBounty = 0.5
  elseif mode == "HARDCORE" then
    multiplierBounty = 0.25
  end

  keys.gold_bounty = keys.gold_bounty * multiplierBounty
  --

  local greed = player:FindAbilityByName("alchemist_goblins_greed")
  if greed ~= nil and greed:GetLevel() > 0 then
    local newBountyGold = keys.gold_bounty * greed:GetSpecialValueFor("bounty_multiplier")
    player:ModifyGold(-keys.gold_bounty, true, 0) 
    player:ModifyGold(newBountyGold, true, 0) 
  end

  return true
end

function barebones:ModifierFilter(event)
  local victim = EntIndexToHScript(event.entindex_parent_const)
  if not victim or victim == nil then return false end

  if not event.entindex_caster_const or event.entindex_caster_const == nil then return false end
  local caster = EntIndexToHScript(event.entindex_caster_const)
  if not caster or caster == nil then return false end

  local modifier = event.name_const
  if modifier ~= nil and IsBossTCOTRPG(victim) then
    for _,ban in ipairs(BANNED_BOSS_MODIFIERS) do
      if modifier == ban then return false end
    end
  end 

  if victim:HasModifier("modifier_kings_guard_aura_enemy") and event.name_const == "modifier_desolator_buff" then
    local mod = victim:FindModifierByName("modifier_kings_guard_aura_enemy")
    if mod ~= nil then
      mod:ForceRefresh()
    end
  end

  if victim:FindAbilityByName("boss_shell_custom") then
    if event.entindex_caster_const ~= event.entindex_parent_const then
      -- check if the modifier is allowed to stack forever --
      for _,modifierException in ipairs(STACKING_MODIFIERS_EXCEPTION) do
        if modifierException == event.name_const then return true end
      end
      ---

      if event.duration > 3 or event.duration == -1 then
        event.duration = 3
      end

      local mod = victim:FindModifierByNameAndCaster(event.name_const, EntIndexToHScript(event.entindex_caster_const))
      Timers:CreateTimer(3.0, function()
        if mod ~= nil and victim:IsAlive() then
          victim:RemoveModifierByName(event.name_const)
        end
      end)
    end
    --event.duration = 3
  end

  return true
end

LinkLuaModifier( "modifier_windranger_windrun_custom_autocast", "heroes/hero_windrunner/windrun_custom.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_autocast_strike", "heroes/hero_lina/laguna_blade.lua", LUA_MODIFIER_MOTION_NONE )

function barebones:OrderFilter(event)
    if event.order_type == DOTA_UNIT_ORDER_CAST_TARGET then
      local target = EntIndexToHScript(event.entindex_target)
      if target == nil then return end

      if target:GetUnitName() == "npc_dota_treasure_chest_building" then return false end

      if IsBossTCOTRPG(target) then
        local ability = EntIndexToHScript(event.entindex_ability)
        if ability == nil then return end
        
        for _,ban in ipairs(BANNED_BOSS_ABILITIES) do
          if ability:GetAbilityName() == ban then
            return false
          end
        end
      end
    end

    if event.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
      local ability = EntIndexToHScript(event.entindex_ability)
      if ability == nil then return end

      local caster = ability:GetCaster()

      if ability:GetAbilityName() == "dawnbreaker_daybreak" then
        if GameRules:IsDaytime() then
            DisplayError(caster:GetPlayerID(), "#dawnbreaker_daybreak_cannot_use")
            return false
        end
      end

      if ability:GetAbilityName() == "lycan_shapeshift_custom" then
        if not GameRules:IsDaytime() then
            DisplayError(caster:GetPlayerID(), "#lycan_shapeshift_cannot_use")
            return false
        end
      end
    end

    if event.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO then
      local ability = EntIndexToHScript(event.entindex_ability)
      if ability == nil then return end

      if ability:GetAbilityName() == "windrunner_windrun"  then
        local caster = ability:GetCaster()
        if not caster:HasModifier("modifier_windranger_windrun_custom_autocast") then
          caster:AddNewModifier(caster, ability, "modifier_windranger_windrun_custom_autocast", {})
        else
          caster:RemoveModifierByNameAndCaster("modifier_windranger_windrun_custom_autocast", caster)
        end
      end

      if ability:GetAbilityName() == "lina_light_strike_array"  then
        local caster = ability:GetCaster()
        if not caster:HasModifier("modifier_lina_laguna_blade_custom_autocast_strike") then
          caster:AddNewModifier(caster, ability, "modifier_lina_laguna_blade_custom_autocast_strike", {})
        else
          caster:RemoveModifierByNameAndCaster("modifier_lina_laguna_blade_custom_autocast_strike", caster)
        end
      end

      if ability:GetAbilityName() == "bloodseeker_bloodrage_custom"  then
        local caster = ability:GetCaster()
        if not caster:HasModifier("modifier_bloodseeker_bloodrage_custom_autocast") then
          caster:AddNewModifier(caster, ability, "modifier_bloodseeker_bloodrage_custom_autocast", {})
        else
          caster:RemoveModifierByNameAndCaster("modifier_bloodseeker_bloodrage_custom_autocast", caster)
        end
      end

      if ability:GetAbilityName() == "dazzle_shadow_wave"  then
        local caster = ability:GetCaster()
        if not caster:HasModifier("modifier_dazzle_shadow_wave_autocast") then
          caster:AddNewModifier(caster, ability, "modifier_dazzle_shadow_wave_autocast", {})
        else
          caster:RemoveModifierByNameAndCaster("modifier_dazzle_shadow_wave_autocast", caster)
        end
      end

      if ability:GetAbilityName() == "bristleback_quill_spray_custom"  then
        local caster = ability:GetCaster()
        if not caster:HasModifier("modifier_bristleback_quill_spray_custom_autocast") then
          caster:AddNewModifier(caster, ability, "modifier_bristleback_quill_spray_custom_autocast", {})
        else
          caster:RemoveModifierByNameAndCaster("modifier_bristleback_quill_spray_custom_autocast", caster)
        end
      end

      if ability:GetAbilityName() == "bristleback_viscous_nasal_goo_custom"  then
        local caster = ability:GetCaster()
        if not caster:HasModifier("modifier_bristleback_viscous_nasal_goo_custom_autocast") then
          caster:AddNewModifier(caster, ability, "modifier_bristleback_viscous_nasal_goo_custom_autocast", {})
        else
          caster:RemoveModifierByNameAndCaster("modifier_bristleback_viscous_nasal_goo_custom_autocast", caster)
        end
      end
    end

    if event.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE then
      local ability = EntIndexToHScript(event.entindex_ability)
      if ability == nil then return end

      local caster = ability:GetCaster()
      if caster:GetUnitName() == "npc_dota_hero_huskar" then
        local mayhem = caster:FindAbilityByName("huskar_mayhem_custom")
        if mayhem ~= nil and mayhem:GetLevel() > 0 then
          if string.find(ability:GetAbilityName(), "armlet") then
            return false
          end
        end
      end
    end

    if event.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or event.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or event.order_type == DOTA_UNIT_ORDER_MOVE_TO_DIRECTION then
      local id = event.issuer_player_id_const
      if not id or id == nil then return end
      if event.units ~= nil then
        if event.units["0"] ~= nil then
          local target = EntIndexToHScript(event.units["0"])
          if target == nil then return end

          if target:HasModifier("modifier_player_difficulty_boon_ally_movement_freeze_3") then
            if _G.MovementFreezeCounter[id] > 0 then
              _G.MovementFreezeCounter[id] = 0
            end
          end
        end
      end
    end

    --[[
    -- block stash --
    -- also prevents courier from picking it up, it seems --
    local notInStash = {
      "item_recipe_kings_guard_7",
      "item_recipe_mercure7",
      "item_recipe_veil_of_discord6",
      "item_recipe_trident_custom_6",
      "item_recipe_rebels_sword",
      "item_recipe_octarine_core6",
      "item_last_soul",
      "item_kings_guard_7",
      "item_mercure7",
      "item_veil_of_discord6",
      "item_rebels_sword",
      "item_octarine_core6",
      "item_trident_custom_6",
    }

    -- prevent from buying recipe when not in shop --
    if event.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM then
      local player = PlayerResource:GetSelectedHeroEntity(event.issuer_player_id_const)

      for _,recipe in ipairs(notInStash) do
        if event.shop_item_name == recipe and not player:IsInRangeOfShop(DOTA_SHOP_HOME, false) then
          DisplayError(event.issuer_player_id_const, "#lost_soul_not_shop")
          return false
        end
      end
    end

    -- Prevent from moving recipes into stash --
    if event.order_type == DOTA_UNIT_ORDER_MOVE_ITEM then
      local item = EntIndexToHScript(event.entindex_ability)
      if not item or item == nil then return end

      for _,recipe in ipairs(notInStash) do
        if item:GetAbilityName() == recipe and (event.entindex_target >= 9 and event.entindex_target <= 14) then
          DisplayError(event.issuer_player_id_const, "#lost_soul_not_stash")
          return false
        end
      end
    end
    --

    local purchasableLostItems = {
      "item_kings_guard_7",
      "item_mercure7",
      "item_veil_of_discord6",
      "item_rebels_sword",
      "item_octarine_core6",
      "item_trident_custom_6",
      "item_last_soul",
    }

    --also give to shopkeeper, isn't counted as selling
    if event.order_type == DOTA_UNIT_ORDER_DROP_ITEM or event.order_type == DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH then
      local itemName = EntIndexToHScript(event.entindex_ability):GetAbilityName()

      local player = PlayerResource:GetSelectedHeroEntity(event.issuer_player_id_const)
      for _,lostItem in ipairs(purchasableLostItems) do
        if itemName == lostItem and _G.lostItems[player:GetPlayerID()] == 1 then
          _G.lostItems[player:GetPlayerID()] = 0
        end
      end
    end
    --]]

    return true
end

function barebones:DamageFilter(event)
  local victim
    local attacker
    local inflictor

    -- Validate variables
    if event.entindex_victim_const then
      victim = EntIndexToHScript(event.entindex_victim_const)
    else
      victim = nil
    end

    if event.entindex_attacker_const then
      attacker = EntIndexToHScript(event.entindex_attacker_const)
    else
      attacker = nil
    end

    if event.entindex_inflictor_const then
      inflictor = EntIndexToHScript(event.entindex_inflictor_const)
    else
      inflictor = nil
    end
    ---

    if attacker == nil or victim == nil then return false end

    local damageType = event.damagetype_const
    local ability

    if IsBossTCOTRPG(victim) then
      if not attacker:IsAlive() then -- Can not inflict damage if not alive
        return false
      end

      if damageType == DAMAGE_TYPE_PURE then 
        --event.damagetype_const = DAMAGE_TYPE_MAGICAL
      end

      -- Prevent damage from banned abilities --
      if event.entindex_inflictor_const then
        ability = EntIndexToHScript(event.entindex_inflictor_const)

        if ability and ability:GetAbilityName() then
          local abilityName = ability:GetAbilityName()

          if not ability:GetCaster():IsAlive() then return false end -- Do not damage if caster is not alive
          
          for _,ban in ipairs(DAMAGE_FILTER_BANNED_BOSS_ABILITIES) do
            if abilityName == ban then return false end
          end

          for _,reduced in ipairs(REDUCED_BOSS_ABILITIES) do
            if abilityName == reduced then
              event.damage = event.damage * 0.05
            end
          end
        end
      end
      --

      -- Break smoke if any damage is dealt
      if attacker:HasModifier("modifier_smoke_of_deceit") then
        attacker:RemoveModifierByName("modifier_smoke_of_deceit")
      end
      --

      -- Won't take damage if they're not within the boss acquisition range --
      if (attacker:GetAbsOrigin() - victim:GetAbsOrigin()):Length2D() > 900 then
        return false
      end

      -- This makes it so they take less damage the less HP they have --
      local bossReduction = victim:GetHealth() / victim:GetMaxHealth()

      if bossReduction < 0.15 then
        bossReduction = 0.15
      end

      event.damage = event.damage * bossReduction
    end

    -- Kingslayer --
    if attacker:HasModifier("modifier_item_kingslayer") then
      local kingslayer = attacker:FindItemInInventory("item_kingslayer")
      if kingslayer ~= nil and not kingslayer:IsInBackpack() then
        -- Victim is non-hero and non-boss --
        if victim:IsRealHero() or victim:IsHero() then
          --event.damage = event.damage * (kingslayer:GetSpecialValueFor("non_boss_damage_decrease") / 100)
          event.damage = 0
          if event.damage <= 0 then
            return false
          end
        end

        -- Victim is boss --
        if IsBossTCOTRPG(victim) and event.damagetype_const == DAMAGE_TYPE_MAGICAL then
          event.damage = event.damage * (kingslayer:GetSpecialValueFor("boss_damage_increase") / 100)
        end
      end
    end
    --

    -- TRIDENT OF THE DEPTHS --
    local tridentAttacker = attacker
    local tridentDamageType = event.damagetype_const
    local tridentInflictor = inflictor

    -- Death Ward --
    if tridentAttacker:GetUnitName() == "npc_dota_witch_doctor_death_ward" then
      local owner = PlayerResource:GetSelectedHeroEntity(tridentAttacker:GetPlayerOwnerID())

      tridentAttacker = owner
      tridentInflictor = owner:FindAbilityByName("witch_doctor_death_ward")

      event.damage = tridentInflictor:GetSpecialValueFor("damage") * (1 - victim:GetMagicalArmorValue())

      event.damagetype_const = DAMAGE_TYPE_MAGICAL
      tridentDamageType = event.damagetype_const
    end
    -- --

    -- Spec Dispersion --
    if victim:HasModifier("modifier_spectre_dispersion_custom_absorb_state") and victim:IsAlive() then
      local dispersionBlock = victim:FindAbilityByName("spectre_dispersion_custom"):GetSpecialValueFor("return_pct")
      event.damage = event.damage * (1 - (dispersionBlock / 100))
    end
    --

    -- Enchanted Armor --
    if victim:HasModifier("modifier_item_enchanted_armor_shield") and victim:IsAlive() then
      local enchantedArmor = nil

      if victim:FindItemInInventory("item_enchanted_armor") ~= nil then
        enchantedArmor = victim:FindItemInInventory("item_enchanted_armor")
      elseif victim:FindItemInInventory("item_enchanted_armor2") ~= nil then
        enchantedArmor = victim:FindItemInInventory("item_enchanted_armor2")
      elseif victim:FindItemInInventory("item_enchanted_armor3") ~= nil then
        enchantedArmor = victim:FindItemInInventory("item_enchanted_armor3")
      elseif victim:FindItemInInventory("item_enchanted_armor4") ~= nil then
        enchantedArmor = victim:FindItemInInventory("item_enchanted_armor4")
      elseif victim:FindItemInInventory("item_enchanted_armor5") ~= nil then
        enchantedArmor = victim:FindItemInInventory("item_enchanted_armor5")
      end

      if enchantedArmor ~= nil and not enchantedArmor:IsInBackpack() and enchantedArmor:IsToggle() and not victim:IsMuted() and not victim:IsHexed() then
        -- This does not return damage before reductions so we need to calculate it ourselves --
        local originalDamage = event.damage 
        if event.damagetype_const == DAMAGE_TYPE_PHYSICAL then
          local armor = victim:GetPhysicalArmorValue(false)
          local physicalResistance = 0.06*armor/(1+0.06*math.abs(armor)) * 100
          originalDamage = event.damage / (1 - (physicalResistance / 100))
        end

        if event.damagetype_const == DAMAGE_TYPE_MAGICAL then
          local armor = victim:GetMagicalArmorValue()
          originalDamage = event.damage / (1 - armor)
        end

        local enchantedArmor_MaxAbsorbedDamage = enchantedArmor:GetSpecialValueFor("max_absorbed_damage_pct")
        local enchantedArmor_DamagePerMana = enchantedArmor:GetSpecialValueFor("damage_per_mana")

        local damageToAbsorb = originalDamage * (enchantedArmor_MaxAbsorbedDamage / 100)
        local currentMana = victim:GetMana()
        local manaToBurn = damageToAbsorb / enchantedArmor_DamagePerMana
        local spareDamage = 0 -- Damage to add back to event.damage if they dont have enough mana

        if manaToBurn > currentMana then
          spareDamage = (manaToBurn - currentMana)

          victim:SpendMana(currentMana, enchantedArmor)
        else
          victim:SpendMana(manaToBurn, enchantedArmor)
        end

        -- Represents the remaining damage the playe should always take after the max absorb amount
        -- E.g. if max absorb is 70% then this represents the 30% that is not absorbed and will damage the player regardless
        local remainingDamage = event.damage * (1 - (enchantedArmor_MaxAbsorbedDamage / 100))
        local outgoingDamage = remainingDamage + spareDamage

        if outgoingDamage < 0 then
          outgoingDamage = 0
        end

        if (outgoingDamage > victim:GetMaxHealth()) then
          event.damage = 0
          victim:SpendMana(victim:GetMana(), enchantedArmor)
          victim:AddNewModifier(victim, nil, "modifier_invulnerable", { duration = enchantedArmor:GetSpecialValueFor("immunity_duration") })
          if enchantedArmor:GetToggleState() then enchantedArmor:ToggleAbility() end
          enchantedArmor:StartCooldown(30.0)
        else
          event.damage = outgoingDamage
        end
      end
    end
    --

    -- Huskar Mayhem --
    --[[
    if victim:GetUnitName() == "npc_dota_hero_huskar" then
      local mayhem = victim:FindAbilityByName("huskar_mayhem_custom")
      if mayhem ~= nil and mayhem:GetLevel() > 0 then
        event.damage = event.damage * (1.0 - (mayhem:GetSpecialValueFor("damage_reduction") / 100))
      end
    end
    --]]
    --

    --[[
    -- Armor Piercing Crossbow --
    if attacker:HasModifier("modifier_item_armor_piercing_crossbow_pierce") and damageType == DAMAGE_TYPE_PHYSICAL and inflictor == nil then
      local crossbowItem = nil

      if attacker:FindItemInInventory("item_armor_piercing_crossbow") ~= nil then
        crossbowItem = attacker:FindItemInInventory("item_armor_piercing_crossbow")
      elseif attacker:FindItemInInventory("item_armor_piercing_crossbow_2") ~= nil then
        crossbowItem = attacker:FindItemInInventory("item_armor_piercing_crossbow_2")
      elseif attacker:FindItemInInventory("item_armor_piercing_crossbow_3") ~= nil then
        crossbowItem = attacker:FindItemInInventory("item_armor_piercing_crossbow_3")
      elseif attacker:FindItemInInventory("item_armor_piercing_crossbow_4") ~= nil then
        crossbowItem = attacker:FindItemInInventory("item_armor_piercing_crossbow_4")
      elseif attacker:FindItemInInventory("item_armor_piercing_crossbow_5") ~= nil then
        crossbowItem = attacker:FindItemInInventory("item_armor_piercing_crossbow_5")
      end

      if crossbowItem ~= nil and not crossbowItem:IsInBackpack() then
        event.damagetype_const = DAMAGE_TYPE_PURE 
        event.damage = event.damage + crossbowItem:GetSpecialValueFor("pierce_damage")
        attacker:RemoveModifierByNameAndCaster("modifier_item_armor_piercing_crossbow_pierce", attacker)
      end
    end
    --]]

    if attacker:HasModifier("modifier_item_star_shard") and damageType == DAMAGE_TYPE_MAGICAL then
      local starShardItem = nil

      if attacker:FindItemInInventory("item_star_shard") ~= nil then
        starShardItem = attacker:FindItemInInventory("item_star_shard")
      elseif attacker:FindItemInInventory("item_star_shard_2") ~= nil then
        starShardItem = attacker:FindItemInInventory("item_star_shard_2")
      elseif attacker:FindItemInInventory("item_star_shard_3") ~= nil then
        starShardItem = attacker:FindItemInInventory("item_star_shard_3")
      elseif attacker:FindItemInInventory("item_star_shard_4") ~= nil then
        starShardItem = attacker:FindItemInInventory("item_star_shard_4")
      elseif attacker:FindItemInInventory("item_star_shard_5") ~= nil then
        starShardItem = attacker:FindItemInInventory("item_star_shard_5")
      elseif attacker:FindItemInInventory("item_star_shard_6") ~= nil then
        starShardItem = attacker:FindItemInInventory("item_star_shard_6")
      end

      if starShardItem ~= nil and not starShardItem:IsInBackpack() then
        event.damage = event.damage + (attacker:GetBaseIntellect() * (starShardItem:GetSpecialValueFor("agi_to_magic_pct")/100))
      end
    end

    -- Chronos --
    if attacker:HasModifier("modifier_item_pendant_of_chronos_active") and damageType == DAMAGE_TYPE_MAGICAL and inflictor == nil then
      local chronosItem = nil

      if attacker:FindItemInInventory("item_pendant_of_chronos") ~= nil then
        chronosItem = attacker:FindItemInInventory("item_pendant_of_chronos")
      elseif attacker:FindItemInInventory("item_pendant_of_chronos_2") ~= nil then
        chronosItem = attacker:FindItemInInventory("item_pendant_of_chronos_2")
      elseif attacker:FindItemInInventory("item_pendant_of_chronos_3") ~= nil then
        chronosItem = attacker:FindItemInInventory("item_pendant_of_chronos_3")
      elseif attacker:FindItemInInventory("item_pendant_of_chronos_4") ~= nil then
        chronosItem = attacker:FindItemInInventory("item_pendant_of_chronos_4")
      elseif attacker:FindItemInInventory("item_pendant_of_chronos_5") ~= nil then
        chronosItem = attacker:FindItemInInventory("item_pendant_of_chronos_5")
      elseif attacker:FindItemInInventory("item_pendant_of_chronos_6") ~= nil then
        chronosItem = attacker:FindItemInInventory("item_pendant_of_chronos_6")
      end

      if chronosItem ~= nil and not chronosItem:IsInBackpack() and RollPercentage(chronosItem:GetSpecialValueFor("pure_chance")) then
        if inflictor:GetAbilityType() ~= ABILITY_TYPE_ULTIMATE then 
          event.damagetype_const = DAMAGE_TYPE_PURE 
          SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, attacker, event.damage, nil)
        end
      end
    end
    --

    if GetMapName() == "5v5" or GetMapName() == "tcotrpg_1v1" then
      if attacker:IsRealHero() and victim:IsRealHero() and (victim:GetTeamNumber() ~= attacker:GetTeamNumber()) then 
        local nwDiff = PlayerResource:GetNetWorth(attacker:GetPlayerID()) / PlayerResource:GetNetWorth(victim:GetPlayerID())
        event.damage = (event.damage / nwDiff) * 0.70
      end
    end

    if victim:HasModifier("modifier_undying_grave_custom") and not victim:HasModifier("modifier_undying_frenzy_custom_buff") then
      local grave = victim:FindAbilityByName("undying_grave_custom")
      if grave ~= nil and grave:GetLevel() > 0 then
        local tombstone = Entities:FindByModel(nil, "models/items/undying/idol_of_ruination/idol_tower.vmdl")
        if tombstone ~= nil then
          if event.damage >= victim:GetHealth() then
            event.damage = 0
            victim:AddNewModifier(victim, grave, "modifier_undying_grave_custom_resurrecting", { duration = 5.0, x = tombstone:GetAbsOrigin().x, y = tombstone:GetAbsOrigin().y, z = tombstone:GetAbsOrigin().z })
            victim:AddNoDraw()
            victim:SetAbsOrigin(tombstone:GetAbsOrigin())
            victim:ForceKill(false)
          end
        end
      end
    end

    if victim:HasModifier("modifier_undying_frenzy_custom_buff") then
      local frenzy = victim:FindAbilityByName("undying_frenzy_custom")
      if frenzy ~= nil and frenzy:GetLevel() > 0 then
        if event.damage >= victim:GetHealth() then
          event.damage = 0
          victim:SetHealth(1)
        end
      end
    end

    if attacker:HasModifier("modifier_boss_zeus_secret") then
      if attacker:FindModifierByName("modifier_boss_zeus_secret"):GetStackCount() > 0 then
        event.damage = event.damage * (1+attacker:FindModifierByName("modifier_boss_zeus_secret"):GetStackCount())
      end
    end

    if attacker:HasModifier("modifier_bloodseeker_thirst_custom_buff_permanent") then
      if attacker:FindModifierByName("modifier_bloodseeker_thirst_custom_buff_permanent"):GetStackCount() > 0 then
        local thirst = attacker:FindAbilityByName("bloodseeker_thirst_custom")
        if thirst ~= nil and thirst:GetLevel() > 0 then
          if victim:GetHealthPercent() <= thirst:GetSpecialValueFor("hp_threshold") then
            event.damage = event.damage * (1+(thirst:GetSpecialValueFor("hp_threshold_bonus_damage_pct")/100))
          end
        end
      end
    end

    if IsCreepTCOTRPG(victim) and attacker:IsRealHero() then
      if attacker:GetLevel() < victim:GetLevel() then
        if event.entindex_inflictor_const ~= nil then
          local ability = EntIndexToHScript(event.entindex_inflictor_const)
          if ability ~= nil then
            local abilityName = ability:GetAbilityName()
            for _,reduced in ipairs(REDUCED_BOSS_ABILITIES) do
              if abilityName == reduced then
                event.damage = 0
                return false
              end
            end
          end
        end
      end
    end

    if victim:HasModifier("modifier_enemy_difficulty_buff_wraith_5_20") and not victim:HasModifier("modifier_enemy_difficulty_buff_wraith_5_20_buff") then
      if event.damage >= victim:GetHealth() then
        event.damage = 0
        victim:SetHealth(victim:GetMaxHealth() * 0.30)
        victim:AddNewModifier(victim, nil, "modifier_enemy_difficulty_buff_wraith_5_20_buff", { duration = 20 })
        return false
      end
    end

    if victim:HasModifier("modifier_enemy_difficulty_buff_wraith_5_10") and not victim:HasModifier("modifier_enemy_difficulty_buff_wraith_5_10_buff") then
      if event.damage >= victim:GetHealth() then
        event.damage = 0
        victim:SetHealth(victim:GetMaxHealth() * 0.30)
        victim:AddNewModifier(victim, nil, "modifier_enemy_difficulty_buff_wraith_5_10_buff", { duration = 10 })
        return false
      end
    end

    if victim:GetUnitName() == "npc_dota_lycan_wolf_custom1" and victim:HasModifier("modifier_lycan_howl_custom_buff") then
      if event.damage >= victim:GetHealth() then
        event.damage = 0
        victim:SetHealth(1)
        return false
      end
    end

    if event.entindex_inflictor_const ~= nil and event.entindex_inflictor_const ~= nil then
      local ability = EntIndexToHScript(event.entindex_inflictor_const)
      if ability ~= nil and attacker:IsAlive() then
        if ability:GetAbilityName() == "monkey_king_boundless_strike_custom" then
          if attacker:GetUnitName() == "npc_dota_monkey_clone_custom" then
            attacker = attacker:GetOwner()
          end

          local mod = attacker:FindModifierByName("modifier_monkey_king_boundless_strike_stack_custom_buff_permanent")
          if mod ~= nil then
            local stackAbility = attacker:FindAbilityByName("monkey_king_boundless_strike_stack_custom")
            if stackAbility ~= nil and stackAbility:GetLevel() > 0 then
              local chance = stackAbility:GetSpecialValueFor("pure_chance") * mod:GetStackCount()
              if chance >= stackAbility:GetSpecialValueFor("pure_chance_max") then
                chance = stackAbility:GetSpecialValueFor("pure_chance_max")
              end

              if RandomFloat(0.0, 100.0) <= chance then
                event.damagetype_const = DAMAGE_TYPE_PURE
              end
            end
          end
        end
      end
    end
    ----
    if ability ~= nil then
      if ability:GetAbilityName() == "lion_fireball" then
        event.damage = event.damage + (attacker:GetIntellect() * (ability:GetSpecialValueFor("int_damage")/100))
      end
    end
    ----
    if ability ~= nil then
      if ability:GetAbilityName() == "shredder_flamethrower" then
        event.damage = event.damage + (attacker:GetStrength() * (ability:GetSpecialValueFor("str_damage_pct")/100))
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, victim, event.damage, nil)
      end
    end
    ----
    local trident = nil

    if tridentAttacker:FindItemInInventory("item_trident_custom_6") ~= nil then
      trident = tridentAttacker:FindItemInInventory("item_trident_custom_6")
    elseif tridentAttacker:FindItemInInventory("item_trident_custom_5") ~= nil then
      trident = tridentAttacker:FindItemInInventory("item_trident_custom_5")
    elseif tridentAttacker:FindItemInInventory("item_trident_custom_4") ~= nil then
      trident = tridentAttacker:FindItemInInventory("item_trident_custom_4")
    elseif tridentAttacker:FindItemInInventory("item_trident_custom_3") ~= nil then
      trident = tridentAttacker:FindItemInInventory("item_trident_custom_3")
    elseif tridentAttacker:FindItemInInventory("item_trident_custom_2") ~= nil then
      trident = tridentAttacker:FindItemInInventory("item_trident_custom_2")
    elseif tridentAttacker:FindItemInInventory("item_trident_custom") ~= nil then
      trident = tridentAttacker:FindItemInInventory("item_trident_custom")
    end

    local critIgnore = {
      "spectre_dispersion",
      "zuus_static_field",
      "death_prophet_spirit_siphon",
      --"obsidian_destroyer_arcane_orb",
      --"silencer_glaives_of_wisdom",
      "item_ultra_blink",
      "item_ultra_blink_2",
      "item_ultra_blink_3",
      "batrider_sticky_napalm",
      --"pudge_rot"
    }
  
    if trident ~= nil and not trident:IsInBackpack() then
      local critChance = trident:GetLevelSpecialValueFor("spell_crit_chance", (trident:GetLevel() - 1))
      local critDmg = trident:GetLevelSpecialValueFor("spell_crit_damage", (trident:GetLevel() - 1))

      if tridentAttacker:IsRealHero() and not victim:IsBuilding() and not victim:IsOther() then
        if tridentInflictor and (tridentDamageType == DAMAGE_TYPE_MAGICAL or tridentDamageType == DAMAGE_TYPE_PURE) then
            for _,banned in ipairs(critIgnore) do
                if tridentInflictor:GetAbilityName() == banned then 
                    return false
                end
            end

            if IsBossTCOTRPG(victim) then
                for _,banned in ipairs(DAMAGE_FILTER_BANNED_BOSS_ABILITIES) do
                    if tridentInflictor:GetAbilityName() == banned then 
                        return false
                    end
                end
            end
            
            --fix radiance and items not critting
            if RollPercentage(critChance) then
                event.damage = event.damage * (critDmg / 100)
                --event.damagetype_const = DAMAGE_TYPE_MAGICAL 

                SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, victim, event.damage, nil)
            end
        end
      end
    end
    ----

    if victim:GetUnitName() == "npc_dota_creature_target_dummy" and attacker:IsRealHero() then
      -- Only works if they're within their own attack range
      if _G.PlayerDamageTest[attacker:GetPlayerID()] == nil then
        _G.PlayerDamageTest[attacker:GetPlayerID()] = 0
      end

      _G.PlayerDamageTest[attacker:GetPlayerID()] = _G.PlayerDamageTest[attacker:GetPlayerID()] + event.damage

      if _G.PlayerDamageTimer[attacker:GetPlayerID()] == nil and event.damagetype_const == DAMAGE_TYPE_PHYSICAL and (attacker:GetAbsOrigin() - victim:GetAbsOrigin()):Length2D() <= attacker:Script_GetAttackRange()+50 then
        GameRules:SendCustomMessage("Starting damage parse for <span color='red'>"..attacker:GetUnitName().."</span>! Ends in 10 seconds...", attacker:GetPlayerID(), 0)
        _G.PlayerDamageTimer[attacker:GetPlayerID()] = Timers:CreateTimer(10, function()
          GameRules:SendCustomMessage("========= (<span color='red'>"..attacker:GetUnitName().."</span>) ===========", attacker:GetPlayerID(), 0)
          GameRules:SendCustomMessage("<span color='gold'>Total Damage: " .. FormatLongNumber(math.floor(_G.PlayerDamageTest[attacker:GetPlayerID()])) .. "</span>", attacker:GetPlayerID(), 0)
          GameRules:SendCustomMessage("<span color='lightgreen'>DPS (Damage Per Second): " .. FormatLongNumber(math.floor(_G.PlayerDamageTest[attacker:GetPlayerID()]/10)) .. "</span>", attacker:GetPlayerID(), 0)
          GameRules:SendCustomMessage("====================", attacker:GetPlayerID(), 0)

          _G.PlayerDamageTest[attacker:GetPlayerID()] = 0
          
          Timers:CreateTimer(5.0, function()
            Timers:RemoveTimer(_G.PlayerDamageTimer[attacker:GetPlayerID()])
            _G.PlayerDamageTimer[attacker:GetPlayerID()] = nil
          end)
        end)
      end

      event.damage = 0
      
      return false
    end

    if event.damage > INT_MAX_LIMIT or event.damage < 0 then
      if string.find(attacker:GetUnitName(), "npc_dota_wave") then return true end
      event.damage = INT_MAX_LIMIT
    end

    return true
end

function barebones:OnNPCSpawned(keys)
  SendToConsole("dota_hud_healthbars 1")
  local npc = EntIndexToHScript(keys.entindex)

  if npc:IsRealHero() then 
    if npc:GetHealth() <= 1 or npc:GetHealth() > INT_MAX_LIMIT then
      npc:SetHealth(INT_MAX_LIMIT)
    end
    
    if not npc:HasModifier("modifier_int_scaling") then
      npc:AddNewModifier(npc, nil, "modifier_int_scaling", {})
    end

    if not npc:HasModifier("modifier_auto_pickup") then
      npc:AddNewModifier(npc, nil, "modifier_auto_pickup", {})
    end

    if npc:IsRealHero() then
      local abilities = _G.PlayerStoredAbilities[npc:GetUnitName()]
      if abilities ~= nil then
        for _,ability in ipairs(abilities) do
          if npc:FindAbilityByName(ability) == nil then
            npc:AddAbility(ability)
          end
        end
      end

      local boot = npc:FindItemInInventory("item_travel_boots_3")
      if boot ~= nil then
        boot:SetLevel(boot:GetLevel())
      end

      if WAVE_VOTE_RESULT == "DISABLE" then
        CustomGameEventManager:Send_ServerToAllClients("waves_disable", {})
      end
    end

    --[[
    if _G.lostItems[npc:GetPlayerID()] == nil then
      _G.lostItems[npc:GetPlayerID()] = 0
    end
    --]]

    if not _G.receivedGold[keys.entindex] then
      PlayerEffects:OnPlayerSpawnedForTheFirstTime(npc)

      local mode = KILL_VOTE_RESULT:upper()

      barebones:InitiateBoonsAndBuffs(mode, npc, 1)

      local startingGoldMultiplier = 0

      if mode == "EASY" then
        startingGoldMultiplier = 1.0
      elseif mode == "NORMAL" then
        startingGoldMultiplier = 1.0
      elseif mode == "HARD" then
        startingGoldMultiplier = 1.0
      elseif mode == "UNFAIR" then
        startingGoldMultiplier = 1.0
      elseif mode == "IMPOSSIBLE" then
        startingGoldMultiplier = 1.0
        npc:AddNewModifier(npc, nil, "modifier_limited_lives", { count = 10 })
      elseif mode == "HELL" then
        startingGoldMultiplier = 1.0
        npc:AddNewModifier(npc, nil, "modifier_limited_lives", { count = 5 })
      elseif mode == "HARDCORE" then
        startingGoldMultiplier = 1.0
        npc:AddNewModifier(npc, nil, "modifier_limited_lives", { count = 1 })
      end

      npc:ModifyGold(-NORMAL_START_GOLD, false, 0)
      npc:ModifyGold((NORMAL_START_GOLD * startingGoldMultiplier), false, 0)

      npc:HeroLevelUp(false)
      npc:HeroLevelUp(false)

      --
      npc:AddItemByName("item_travel_boots_3")
      local bootLevelCount = 1
      Timers:CreateTimer(600, function()
        if bootLevelCount >= 5 then return end

        local boot = npc:FindItemInInventory("item_travel_boots_3")
        if boot ~= nil then
          boot:SetLevel(boot:GetLevel()+1)
          npc:FindModifierByName("modifier_item_travel_boots_3"):ForceRefresh()
          bootLevelCount = bootLevelCount + 1
        end

        return 600
      end)
      --

      _G.receivedGold[keys.entindex] = true
      if _G.PlayerNeutralDropCooldowns[npc:GetPlayerID()] == nil then
        _G.PlayerNeutralDropCooldowns[npc:GetPlayerID()] = false
      end
    end
  end

  if npc:IsCourier() then
    npc:AddNewModifier(npc, nil, "modifier_invulnerable", {})
  end

  if (IsCreepTCOTRPG(npc) or IsBossTCOTRPG(npc)) and (npc:GetOwner() == nil) and #KILL_VOTE_RESULT > 0 and npc:GetUnitName() ~= "npc_dota_creature_target_dummy" then
    local mode = KILL_VOTE_RESULT:upper()
    local multiplierDamage = 0
    local multiplierHealth = 0
    local multiplierBounty = 0

    if mode == "EASY" then
      multiplierBounty = 2.0
      multiplierDamage = 0.5
      multiplierHealth = 0.5
    elseif mode == "NORMAL" then
      multiplierDamage = 1.0
      multiplierHealth = 1.0
      multiplierBounty = 1.0
    elseif mode == "HARD" then
      multiplierBounty = 1.0
      multiplierDamage = 2.0
      multiplierHealth = 3.0
    elseif mode == "UNFAIR" then
      multiplierBounty = 0.9
      multiplierDamage = 3.0
      multiplierHealth = 5.0
    elseif mode == "IMPOSSIBLE" then
      multiplierBounty = 0.8
      multiplierDamage = 5.0
      multiplierHealth = 10.0
    elseif mode == "HELL" then
      -- Every time enemies spawn, their strength is increased by the minute
      -- Ultimately this does not really affect the first final boss or bosses the first time they spawn (only after)
      --multiplier = 10.0 + (math.floor(GameRules:GetGameTime() / 60) / 10)

      -- The gold from creeps will decrease over time. After 90 minutes you only gain 10% of the original bounty
      --multiplierBounty = 1.0 - (math.floor(GameRules:GetGameTime() / 60) / 100)
      multiplierBounty = 0.7
      multiplierDamage = 10.0
      multiplierHealth = 20.0
    elseif mode == "HARDCORE" then
      multiplierBounty = 0.6
      multiplierDamage = 20.0
      multiplierHealth = 50.0
    end

    if multiplierDamage > 0 and multiplierHealth > 0 and multiplierBounty > 0 then
      -- Bounty --
      local bounty = npc:GetGoldBounty() * multiplierBounty
      if bounty < 0 then
        bounty = 0
      end

      if bounty > INT_MAX_LIMIT then
        bounty = INT_MAX_LIMIT
      end

      npc:SetMaximumGoldBounty(bounty)
      npc:SetMinimumGoldBounty(bounty)

      -- HP --
      local hp = npc:GetMaxHealth() * multiplierHealth
      if hp > INT_MAX_LIMIT or hp <= 0 then
        hp = INT_MAX_LIMIT
      end

      npc:SetBaseMaxHealth(hp)
      npc:SetMaxHealth(hp)
      npc:SetHealth(hp)

      -- DAMAGE --
      local damage = npc:GetAverageTrueAttackDamage(npc) * multiplierDamage
      if damage > INT_MAX_LIMIT or damage <= 0 then
        if not string.find(npc:GetUnitName(), "npc_dota_wave") then 
          damage = INT_MAX_LIMIT
        end
      end

      npc:SetBaseDamageMax(damage)
      npc:SetBaseDamageMin(damage)

      if not IsBossTCOTRPG(npc) then
        barebones:InitiateBoonsAndBuffs(mode, npc, 2)
      end
    end
  end

  if npc:GetUnitName() == "npc_dota_creature_target_dummy" then
    npc:AddNewModifier(npc, nil, "modifier_dummy_target", {})
  end

  if npc:GetUnitName() == "npc_dota_hero_lion" then
    local agony = npc:FindAbilityByName("lion_agony")
    if agony ~= nil then
      agony:SetLevel(1)
    end
  end

  if npc:GetUnitName() == "npc_dota_hero_undying" then
    local livingDead = npc:FindAbilityByName("undying_flesh_golem_custom")
    if livingDead ~= nil then
      livingDead:SetLevel(1)
    end
  end

  if npc:GetUnitName() == "npc_dota_hero_monkey_king" then
    local boundless = npc:FindAbilityByName("monkey_king_boundless_strike_stack_custom")
    if boundless ~= nil then
      boundless:SetLevel(1)
    end

    local boundlessPassiveProc = npc:FindAbilityByName("monkey_king_boundless_passive_proc_custom")
    if boundlessPassiveProc ~= nil then
      boundlessPassiveProc:SetLevel(1)
    end
  end
end

function barebones:InitiateBoonsAndBuffs(mode, target, targetType)
  if mode == "EASY"  then
    if targetType == 1 then
      for _,mod in ipairs(_G.DifficultyEasyBuffs) do
        target:AddNewModifier(target, nil, mod, {})
      end
    end
  elseif mode == "NORMAL" then
    if targetType == 1 then
      for _,mod in ipairs(_G.DifficultyNormalPlayerBuffs) do
        target:AddNewModifier(target, nil, mod, {})
      end
    else
      for _,mod in ipairs(_G.DifficultyNormalEnemyBuffs) do
        target:AddNewModifier(target, nil, mod, {})
      end
    end
  elseif mode == "HARD" then
    if targetType == 1 then
      for _,mod in ipairs(_G.DifficultyHardPlayerBoons) do
        target:AddNewModifier(target, nil, mod, {})
      end
    else
      for _,mod in ipairs(_G.DifficultyHardEnemyBuffs) do
        target:AddNewModifier(target, nil, mod, {})
      end
    end
  elseif mode == "UNFAIR" then
    if targetType == 1 then
      for _,mod in ipairs(_G.DifficultyUnfairPlayerBoons) do
        target:AddNewModifier(target, nil, mod, {})
      end
    else
      for _,mod in ipairs(_G.DifficultyUnfairEnemyBuffs) do
        target:AddNewModifier(target, nil, mod, {})
      end
    end
  elseif mode == "IMPOSSIBLE" then
    if targetType == 1 then
      for _,mod in ipairs(_G.DifficultyImpossiblePlayerBoons) do
        target:AddNewModifier(target, nil, mod, {})
      end
    else
      for _,mod in ipairs(_G.DifficultyImpossibleEnemyBuffs) do
        target:AddNewModifier(target, nil, mod, {})
      end
    end
  elseif mode == "HELL" then
    if targetType == 1 then
      for _,mod in ipairs(_G.DifficultyHellPlayerBoons) do
        target:AddNewModifier(target, nil, mod, {})
      end
    else
      for _,mod in ipairs(_G.DifficultyHellEnemyBuffs) do
        target:AddNewModifier(target, nil, mod, {})
      end
    end
  elseif mode == "HARDCORE" then
    if targetType == 1 then
      for _,mod in ipairs(_G.DifficultyHardcorePlayerBoons) do
        target:AddNewModifier(target, nil, mod, {})
      end
    else
      for _,mod in ipairs(_G.DifficultyHardcoreEnemyBuffs) do
        target:AddNewModifier(target, nil, mod, {})
      end
    end
  end

  
end

-- This function is called as the first player loads and sets up the game mode parameters
function barebones:CaptureGameMode()
  local gamemode = GameRules:GetGameModeEntity()

  -- Set GameMode parameters
  gamemode:SetRecommendedItemsDisabled(RECOMMENDED_BUILDS_DISABLED)
  gamemode:SetCameraDistanceOverride(CAMERA_DISTANCE_OVERRIDE)
  gamemode:SetBuybackEnabled(BUYBACK_ENABLED)
  gamemode:SetCustomBuybackCostEnabled(CUSTOM_BUYBACK_COST_ENABLED)
  gamemode:SetCustomBuybackCooldownEnabled(CUSTOM_BUYBACK_COOLDOWN_ENABLED)
  gamemode:SetTopBarTeamValuesOverride(USE_CUSTOM_TOP_BAR_VALUES) -- Probably does nothing, but I will leave it
  gamemode:SetTopBarTeamValuesVisible(TOP_BAR_VISIBLE)
  gamemode:SetGiveFreeTPOnDeath(false)

  if USE_CUSTOM_XP_VALUES then
    gamemode:SetUseCustomHeroLevels(true)
    gamemode:SetCustomXPRequiredToReachNextLevel(XP_PER_LEVEL_TABLE)
  end

  gamemode:SetBotThinkingEnabled(USE_STANDARD_DOTA_BOT_THINKING)
  gamemode:SetTowerBackdoorProtectionEnabled(ENABLE_TOWER_BACKDOOR_PROTECTION)

  gamemode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
  gamemode:SetGoldSoundDisabled(DISABLE_GOLD_SOUNDS)
  --gamemode:SetRemoveIllusionsOnDeath(REMOVE_ILLUSIONS_ON_DEATH) -- Didnt work last time I tried

  gamemode:SetAlwaysShowPlayerInventory(SHOW_ONLY_PLAYER_INVENTORY)
  --gamemode:SetAlwaysShowPlayerNames(true) -- use this when you need to hide real hero names
  gamemode:SetAnnouncerDisabled(DISABLE_ANNOUNCER)

  if FORCE_PICKED_HERO ~= nil then
    gamemode:SetCustomGameForceHero(FORCE_PICKED_HERO) -- THIS WILL NOT WORK when "EnablePickRules" is "1" in 'addoninfo.txt' !
  else
    gamemode:SetDraftingHeroPickSelectTimeOverride(HERO_SELECTION_TIME)
    gamemode:SetDraftingBanningTimeOverride(0)
    if ENABLE_BANNING_PHASE then
      gamemode:SetDraftingBanningTimeOverride(BANNING_PHASE_TIME)
      GameRules:SetCustomGameBansPerTeam(5)
    end
  end

  --gamemode:SetFixedRespawnTime(FIXED_RESPAWN_TIME) -- FIXED_RESPAWN_TIME should be float
  gamemode:SetFountainConstantManaRegen(FOUNTAIN_CONSTANT_MANA_REGEN)
  gamemode:SetFountainPercentageHealthRegen(FOUNTAIN_PERCENTAGE_HEALTH_REGEN)
  gamemode:SetFountainPercentageManaRegen(FOUNTAIN_PERCENTAGE_MANA_REGEN)
  gamemode:SetLoseGoldOnDeath(LOSE_GOLD_ON_DEATH)
  gamemode:SetMaximumAttackSpeed(MAXIMUM_ATTACK_SPEED)
  gamemode:SetMinimumAttackSpeed(MINIMUM_ATTACK_SPEED)
  gamemode:SetStashPurchasingDisabled(DISABLE_STASH_PURCHASING)

  if USE_DEFAULT_RUNE_SYSTEM then
    gamemode:SetUseDefaultDOTARuneSpawnLogic(true)
  else
    -- Some runes are broken by Valve, RuneSpawnFilter also didn't work last time I tried
    for rune, spawn in pairs(ENABLED_RUNES) do
      gamemode:SetRuneEnabled(rune, spawn)
    end
    gamemode:SetBountyRuneSpawnInterval(BOUNTY_RUNE_SPAWN_INTERVAL)
    gamemode:SetPowerRuneSpawnInterval(POWER_RUNE_SPAWN_INTERVAL)
  end

  gamemode:SetUnseenFogOfWarEnabled(USE_UNSEEN_FOG_OF_WAR)
  --gamemode:SetDaynightCycleDisabled(DISABLE_DAY_NIGHT_CYCLE)
  GameRules:GetGameModeEntity():SetDaynightCycleDisabled(false)
  gamemode:SetKillingSpreeAnnouncerDisabled(DISABLE_KILLING_SPREE_ANNOUNCER)
  gamemode:SetStickyItemDisabled(DISABLE_STICKY_ITEM)
  gamemode:SetPauseEnabled(ENABLE_PAUSING)
  gamemode:SetCustomScanCooldown(CUSTOM_SCAN_COOLDOWN)
  gamemode:SetCustomGlyphCooldown(CUSTOM_GLYPH_COOLDOWN)
  gamemode:DisableHudFlip(FORCE_MINIMAP_ON_THE_LEFT)
  gamemode:SetTPScrollSlotItemOverride("item_travel_boots_3")
  gamemode:SetFreeCourierModeEnabled(true)

  
end

function barebones:OnPlayerChat(keys)
  if not IsServer() then return end

  local teamonly = keys.teamonly
  local userID = keys.userid
  local text = keys.text
  local steamid = tostring(PlayerResource:GetSteamID(keys.playerid))
  if steamid == "76561198290873082" or steamid == "76561198083843808" then
    for str in string.gmatch(text, "%S+") do

      if str == "-dev_win" then
        GameRules:SetGameWinner(PlayerResource:GetPlayer(keys.playerid):GetTeamNumber())
      end

      if str == "-dev_padla" then
        if PlayerResource:GetPlayer(keys.playerid):GetAssignedHero():GetUnitName() ~= "npc_dota_hero_riki" then
          PlayerResource:ReplaceHeroWithNoTransfer(keys.playerid, "npc_dota_hero_riki", 0, 0)
        end
      end

    end
  end

  if steamid == "76561198376130254" then
    for str in string.gmatch(text, "%S+") do

      if str == "-dev_gavno" then
        if PlayerResource:GetPlayer(keys.playerid):GetAssignedHero():GetUnitName() ~= "npc_dota_hero_padla" then
          PlayerResource:ReplaceHeroWithNoTransfer(keys.playerid, "npc_dota_hero_padla", 0, 0)
        end
      end

    end
  end
  
  
  local player = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()
  if player:HasModifier("modifier_effect_private") then
    for str in string.gmatch(text, "%S+") do
      if str == "-dev_meepo" then
        if PlayerResource:GetPlayer(keys.playerid):GetAssignedHero():GetUnitName() ~= "npc_dota_hero_meepo" then
          --PlayerResource:ReplaceHeroWithNoTransfer(keys.playerid, "npc_dota_hero_meepo", 0, 0)
        end
      end

      if str == "-dev_maxlevel" then
        --HeroMaxLevel(player)
      end

      if str == "-dev_maxgold" then
        --player:ModifyGold(99999, false, DOTA_ModifyGold_Unspecified)
      end

      if str == "-dev_rainbowitems" then
        --player:AddItemByName("item_mjollnir8")
        --player:AddItemByName("item_bloodstone_strygwyr_6")
        --player:AddItemByName("item_desolator8")
      end

      if str == "-dev_endmysuffering" then
        --player:AddNewModifier(player, nil, "modifier_invulnerable", {})
      end
    end
  end
end
require("modules/waves/enemies")

LinkLuaModifier("modifier_wave_ai", "modules/waves/ai.lua", LUA_MODIFIER_MOTION_NONE)

WAVE_BREAK_TIME = 30
WAVE_INTERVAL = 30

function InitiateWaves()
    if not _G.bWavesEnabled then CustomGameEventManager:Send_ServerToAllClients("waves_disable", {}) return end

    local spawnPosition = Entities:FindByName(nil, "wave_spawner"):GetAbsOrigin()

    local count = 0
    local _interval = WAVE_INTERVAL
    local currentWave = 0

    Timers:CreateTimer(1.0, function()
        local baseAncient = Entities:FindByName(nil, "base_ancient")
        if baseAncient == nil or not baseAncient then return end

        local remainingHealth = baseAncient:GetHealth() / baseAncient:GetMaxHealth()

        local ability_Storm = baseAncient:FindAbilityByName("razor_eye_of_the_storm_ancient")
        local ability_Ravage = baseAncient:FindAbilityByName("tidehunter_ravage_ancient")
        local ability_Overgrowth = baseAncient:FindAbilityByName("treant_overgrowth_ancient")
        local ability_Time = baseAncient:FindAbilityByName("abaddon_borrowed_time_ancient")

        if remainingHealth <= 0.75 and ability_Storm:IsCooldownReady() then
            baseAncient:CastAbilityImmediately(ability_Storm, 1)
            ability_Storm:StartCooldown(300)
        elseif remainingHealth <= 0.5 and ability_Ravage:IsCooldownReady() then
            baseAncient:CastAbilityImmediately(ability_Ravage, 1)
            ability_Ravage:StartCooldown(300)
        elseif remainingHealth <= 0.25 and ability_Overgrowth:IsCooldownReady() then
            baseAncient:CastAbilityImmediately(ability_Overgrowth, 1)
            ability_Overgrowth:StartCooldown(300)
        elseif remainingHealth <= 0.1 and ability_Time:IsCooldownReady() then
            baseAncient:CastAbilityImmediately(ability_Time, 1)
            ability_Time:StartCooldown(300)
        end

        return 1.0
    end)

    function StartPanoramaTimer()
        Timers:CreateTimer(1.0, function()
            if not _G.bWavesEnabled then CustomGameEventManager:Send_ServerToAllClients("waves_disable", {}) return end
            
            if count >= WAVE_INTERVAL then
                -- states 
                -- 1 = on hold 
                -- 2 = counting
                CustomNetTables:SetTableValue("waves", "game_info", { wave = currentWave, progress = count, state = 1, max_interval = WAVE_INTERVAL, interval = _interval })
                Timers:CreateTimer(WAVE_BREAK_TIME, function()
                    if count < WAVE_INTERVAL then return end
                    count = 0
                    _interval = WAVE_INTERVAL
                    
                end)
            else
                _interval = _interval - 1
                count = count + 1
                CustomNetTables:SetTableValue("waves", "game_info", { wave = currentWave, progress = count, state = 2, max_interval = WAVE_INTERVAL, interval = _interval }) -- This is the percentage
            end
            
            return 1.0
        end)
    end
    
    
    local i = 1
    StartPanoramaTimer()

    Timers:CreateTimer(WAVE_INTERVAL, function()
        if i > #WAVES or not _G.bWavesEnabled then 
            _G.bWavesEnabled = false
            CustomGameEventManager:Send_ServerToAllClients("waves_disable", {})
            return 
        end

        currentWave = currentWave + 1
        for _,unitName in ipairs(WAVES[i]) do
            if RandomInt(1, 100) <= 5 and not string.find(unitName, "boss") then
                unitName = "npc_dota_wave_gold_chest"
            end

            Timers:CreateTimer(i/#WAVES[i], function()
                CreateUnitByNameAsync(unitName, spawnPosition, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
                    unit:AddNewModifier(nil, nil, "modifier_phased", { duration = 0.2 })
                    unit:CreatureLevelUp(currentWave)

                    unit:AddNewModifier(unit, nil, "modifier_wave_ai", {})
                end)
            end)
        end

        i = i + 1

        return (WAVE_INTERVAL+WAVE_BREAK_TIME)
    end)
end
PlayerEffects = PlayerEffects or class({})

require("modules/effects/player/private")

function PlayerEffects:OnPlayerSpawnedForTheFirstTime(player)
    if not player or player:IsNull() then return end
    if not player:IsRealHero() then return end

    local playerID = player:GetPlayerID()
    local steamID = tostring(PlayerResource:GetSteamID(playerID))

    for _,privateID in pairs(PRIVATE_IDS) do
        if steamID == privateID then
            player:AddNewModifier(player, nil, "modifier_effect_private", {})
        end
    end
end
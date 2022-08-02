LinkLuaModifier("modifier_auto_pickup", "modifiers/modifier_auto_pickup.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
}

auto_pickup = class(ItemBaseClass)
modifier_auto_pickup = class(auto_pickup)

-----------------
function auto_pickup:GetIntrinsicModifierName()
    return "modifier_auto_pickup"
end
-----------------
function modifier_auto_pickup:DeclareFunctions()
    return {}
end

function modifier_auto_pickup:OnCreated(params)
    if not IsServer() then return end

    self.player = self:GetParent()

    self:StartIntervalThink(1.0)
end

--bug: doesn't disable if you turn it off

function modifier_auto_pickup:OnIntervalThink()
    if not self:GetParent():IsAlive() then return end
    
    local searchRadius = self.player:Script_GetAttackRange()
    if not self.player:IsRangedAttacker() then
        searchRadius = searchRadius + 150
    end

    function LootItem(itemName)
        local item = self.player:AddItemByName(itemName)
        if not item then return end
        item:SetPurchaseTime(0)

        if string.find(item:GetAbilityName(), "item_tome") then
            item:OnSpellStart()
        end
    end

    function GetDistanceToItem(player, item)
        return (player:GetOrigin() - item:GetOrigin()):Length2D()
    end

    function IsSelfNearest(item)
        local playersAroundMe = FindUnitsInRadius(self.player:GetTeam(), self.player:GetAbsOrigin(), nil,
            searchRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST, false)

        local isNearest = true

        for _,otherPlayer in ipairs(playersAroundMe) do
            if not otherPlayer:IsAlive() or not _G.autoPickup[otherPlayer:GetPlayerID()] then break end

            if GetDistanceToItem(otherPlayer, item) < GetDistanceToItem(self.player, item) then
                isNearest = false
                break
            end
        end

        return isNearest
    end

    if _G.autoPickup[self:GetParent():GetPlayerID()] then
        local items_on_the_ground = Entities:FindAllByClassname("dota_item_drop")
        for _,item in pairs(items_on_the_ground) do
            local containedItem = item:GetContainedItem()
            if containedItem then
                local owner = containedItem:GetOwnerEntity()
                local name = containedItem:GetAbilityName()

                if not string.find(name, "soul") and not string.find(name, "item_gold_bag") and not string.find(name, "item_piece") and not containedItem:IsNeutralDrop() then
                    --todo:make sure the other player earound also has it toggled on
                    if owner == nil then
                        if self.player:HasAnyAvailableInventorySpace() and (GetDistanceToItem(self.player, item) <= searchRadius) and IsSelfNearest(item) then
                            local purchaser = containedItem:GetPurchaser()

                            if purchaser ~= nil then break end

                            UTIL_RemoveImmediate(item)
                            UTIL_RemoveImmediate(containedItem)

                            LootItem(name)
                        end
                    end
                end
            end

            --[[if owner == nil then
                if IsSelfNearest(item) then
                    UTIL_RemoveImmediate(item)
                    LootItem(name)
                end
            end--]]
        end
    end
end

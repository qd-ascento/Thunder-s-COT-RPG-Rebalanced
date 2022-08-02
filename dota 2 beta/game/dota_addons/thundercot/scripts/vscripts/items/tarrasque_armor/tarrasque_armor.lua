LinkLuaModifier("modifier_item_tarrasque_armor", "items/tarrasque_armor/tarrasque_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_tarrasque_armor_active", "items/tarrasque_armor/tarrasque_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_tarrasque_armor_stacks", "items/tarrasque_armor/tarrasque_armor.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassActive = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return false end,
}

local ItemBaseClassStacks = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return true end,
    IsDebuff = function(self) return false end,
}

item_tarrasque_armor = class(ItemBaseClass)
item_tarrasque_armor_2 = item_tarrasque_armor
item_tarrasque_armor_3 = item_tarrasque_armor
item_tarrasque_armor_4 = item_tarrasque_armor
item_tarrasque_armor_5 = item_tarrasque_armor
item_tarrasque_armor_6 = item_tarrasque_armor
modifier_item_tarrasque_armor = class(ItemBaseClass)
modifier_item_tarrasque_armor_active = class(ItemBaseClassActive)
modifier_item_tarrasque_armor_stacks = class(ItemBaseClassStacks)
-------------
function item_tarrasque_armor:GetIntrinsicModifierName()
    return "modifier_item_tarrasque_armor"
end

function item_tarrasque_armor:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local ability = self
    local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
    
    caster:AddNewModifier(caster, ability, "modifier_item_tarrasque_armor_active", { duration = duration })
end
---
function modifier_item_tarrasque_armor_stacks:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
---
function modifier_item_tarrasque_armor:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS, --GetModifierHealthBonus
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, --GetModifierConstantHealthRegen
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --GetModifierPhysicalArmorBonus
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, --GetModifierBonusStats_Strength
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, --GetModifierHealthRegenPercentage
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK, --GetModifierPhysical_ConstantBlock
        --MODIFIER_EVENT_ON_TAKEDAMAGE, --OnTakeDamage
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, --GetModifierIncomingDamage_Percentage
    }

    return funcs
end

function modifier_item_tarrasque_armor:OnTakeDamage(event)
    if not IsServer() then return end

    if self:GetParent() ~= event.unit then return end

    local ability = self:GetAbility()
    local parent = self:GetParent()
    local threshold = ability:GetSpecialValueFor("hp_charge_threshold_pct")

    self:ForceRefresh() -- To update the block constant

    if event.damage > (parent:GetMaxHealth() * (threshold/100)) then
        if not parent:HasModifier("modifier_item_tarrasque_armor_stacks") then
            local mod = parent:AddNewModifier(parent, ability, "modifier_item_tarrasque_armor_stacks", {})
            if mod ~= nil then
                mod:SetStackCount(1)
            end
        else
            local mod = parent:FindModifierByNameAndCaster("modifier_item_tarrasque_armor_stacks", parent)
            if not mod then return end
            if mod:GetStackCount() >= ability:GetSpecialValueFor("max_charges") then return end
            mod:IncrementStackCount()
        end
    end
end

function modifier_item_tarrasque_armor:OnCreated()
    local ability = self:GetAbility()
    local parent = self:GetParent()
    
    self.block = parent:GetMaxHealth() * (ability:GetSpecialValueFor("max_hp_block_pct")/100)

    if not IsServer() then return end
    local mod = parent:FindModifierByNameAndCaster("modifier_item_tarrasque_armor_stacks", parent)
    if mod ~= nil then
        self.reductionTotal = (ability:GetSpecialValueFor("damage_reduction_per_charge_pct") * mod:GetStackCount())
    end
    self:StartIntervalThink(1.0)
end

function modifier_item_tarrasque_armor:OnRefresh()
    local ability = self:GetAbility()
    local parent = self:GetParent()
        
    self.reductionTotal = nil
    self.block = parent:GetMaxHealth() * (ability:GetSpecialValueFor("max_hp_block_pct")/100)

    if not IsServer() then return end
    local mod = parent:FindModifierByNameAndCaster("modifier_item_tarrasque_armor_stacks", parent)
    if mod ~= nil then
        self.reductionTotal = (ability:GetSpecialValueFor("damage_reduction_per_charge_pct") * mod:GetStackCount())
    end
end

function modifier_item_tarrasque_armor:OnRemoved()
    if not IsServer() then return end

    local parent = self:GetParent()

    parent:RemoveModifierByNameAndCaster("modifier_item_tarrasque_armor_stacks", caster)
end

function modifier_item_tarrasque_armor:GetModifierIncomingDamage_Percentage(event)
    if self:GetParent() ~= event.target then return 0 end
    
    local caster = self:GetCaster()

    if caster:FindAbilityByName("bristleback_bristleback") ~= nil then return 0 end
    if caster:FindAbilityByName("mars_bulwark") ~= nil then return 0 end
    if caster:FindAbilityByName("treant_bark_custom") ~= nil then return 0 end
    if caster:FindAbilityByName("huskar_mayhem_custom") ~= nil then return 0 end

    if caster:HasItemInInventory("item_tarrasque_armor") then return 0 end
    if caster:HasItemInInventory("item_tarrasque_armor_2") then return 0 end
    if caster:HasItemInInventory("item_tarrasque_armor_3") then return 0 end
    if caster:HasItemInInventory("item_tarrasque_armor_4") then return 0 end
    if caster:HasItemInInventory("item_tarrasque_armor_5") then return 0 end
    if caster:HasItemInInventory("item_tarrasque_armor_6") then return 0 end

    if caster:HasItemInInventory("item_kings_guard") then return 0 end
    if caster:HasItemInInventory("item_kings_guard_2") then return 0 end
    if caster:HasItemInInventory("item_kings_guard_3") then return 0 end
    if caster:HasItemInInventory("item_kings_guard_4") then return 0 end
    if caster:HasItemInInventory("item_kings_guard_5") then return 0 end
    if caster:HasItemInInventory("item_kings_guard_6") then return 0 end
    if caster:HasItemInInventory("item_kings_guard_7") then return 0 end

    if caster:HasModifier("modifier_centaur_stampede") then return 0 end
    if caster:HasModifier("modifier_pudge_hunger_custom_buff_goal_5") then return 0 end

    if self.reductionTotal ~= nil then
        return -self.reductionTotal
    end
end

function modifier_item_tarrasque_armor:GetModifierPhysical_ConstantBlock()
    return self.block
end

function modifier_item_tarrasque_armor:GetModifierHealthBonus()
    return self:GetAbility():GetLevelSpecialValueFor("bonus_health", (self:GetAbility():GetLevel() - 1))
end

function modifier_item_tarrasque_armor:GetModifierConstantHealthRegen()
    return self:GetAbility():GetLevelSpecialValueFor("bonus_hp_regen", (self:GetAbility():GetLevel() - 1))
end

function modifier_item_tarrasque_armor:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetLevelSpecialValueFor("bonus_armor", (self:GetAbility():GetLevel() - 1))
end

function modifier_item_tarrasque_armor:GetModifierBonusStats_Strength()
    return self:GetAbility():GetLevelSpecialValueFor("bonus_strength", (self:GetAbility():GetLevel() - 1))
end

function modifier_item_tarrasque_armor:GetModifierHealthRegenPercentage()
    return self:GetAbility():GetLevelSpecialValueFor("hp_regen_pct", (self:GetAbility():GetLevel() - 1))
end

function modifier_item_tarrasque_armor:OnIntervalThink()
    local caster = self:GetCaster()
    if not caster:IsAlive() then return end

    --[[
    if caster:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_STRENGTH then
        caster:DropItemAtPositionImmediate(self:GetAbility(), caster:GetAbsOrigin())
        DisplayError(caster:GetPlayerID(), "#primary_strength_item")
        self:StartIntervalThink(-1)
    end
    --]]

    local ability = self:GetAbility()
    local mod = nil

    mod = caster:FindModifierByNameAndCaster("modifier_item_tarrasque_armor_stacks", caster)

    if not mod then 
        mod = caster:AddNewModifier(caster, ability, "modifier_item_tarrasque_armor_stacks", {})
    end

    if mod:GetStackCount() >= ability:GetSpecialValueFor("max_charges") then return end
    mod:IncrementStackCount()
    self:ForceRefresh()
end
---
function modifier_item_tarrasque_armor_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, --GetModifierBonusStats_Strength
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, --GetModifierIncomingDamage_Percentage
    }

    return funcs
end

function modifier_item_tarrasque_armor_active:AddCustomTransmitterData()
    return
    {
        regen = self.fRegen,
    }
end

function modifier_item_tarrasque_armor_active:HandleCustomTransmitterData(data)
    if data.regen ~= nil then
        self.fRegen = tonumber(data.regen)
    end
end

function modifier_item_tarrasque_armor_active:InvokeRegen()
    if IsServer() == true then
        self.fRegen = self.regen

        self:SendBuffRefreshToClients()
    end
end

function modifier_item_tarrasque_armor_active:GetModifierBonusStats_Strength()
    return self.fRegen
end

function modifier_item_tarrasque_armor_active:GetModifierIncomingDamage_Percentage(event)
    if self:GetParent() ~= event.target then return end

    if self.reduction ~= nil then
        return -self.reduction
    end
end

function modifier_item_tarrasque_armor_active:OnCreated(params)
    self:SetHasCustomTransmitterData(true)

    self.regen = 0

    if not IsServer() then return end

    local parent = self:GetParent()
    local ability = self:GetAbility()

    EmitSoundOn("Item.CrimsonGuard.Cast", parent)

    self.reduction = nil

    local mod = parent:FindModifierByNameAndCaster("modifier_item_tarrasque_armor_stacks", parent)
    if not mod then return end

    self.regen = (parent:GetBaseStrength() * (ability:GetSpecialValueFor("str_per_charge_pct")/100)) * mod:GetStackCount()
    self.reduction = (ability:GetSpecialValueFor("active_damage_reduction_per_charge_pct") * mod:GetStackCount())

    self:InvokeRegen()

    parent:RemoveModifierByNameAndCaster("modifier_item_tarrasque_armor_stacks", parent)
end

function modifier_item_tarrasque_armor_active:GetEffectName()
    return "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield_bubble_outer.vpcf"
end

function modifier_item_tarrasque_armor_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_tarrasque_armor_stacks:GetTexture() return "tarrasque_armor" end
function modifier_item_tarrasque_armor_active:GetTexture() return "tarrasque_armor" end
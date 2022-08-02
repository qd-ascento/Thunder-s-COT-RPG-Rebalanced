LinkLuaModifier("modifier_kings_guard", "items/kings_guard/item_kings_guard.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kings_guard_aura", "items/kings_guard/item_kings_guard.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kings_guard_aura_enemy", "items/kings_guard/item_kings_guard.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassAura = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
}

item_kings_guard = class(ItemBaseClass)
item_kings_guard_2 = item_kings_guard
item_kings_guard_3 = item_kings_guard
item_kings_guard_4 = item_kings_guard
item_kings_guard_5 = item_kings_guard
item_kings_guard_6 = item_kings_guard
item_kings_guard_7 = item_kings_guard
modifier_kings_guard = class(item_kings_guard)
modifier_kings_guard_aura = class(ItemBaseClassAura)
modifier_kings_guard_aura_enemy = class(ItemBaseClassAura)

function modifier_kings_guard_aura:GetTexture() return "kings_guard" end
function modifier_kings_guard_aura_enemy:GetTexture() return "kings_guard" end
-------------
function item_kings_guard:GetIntrinsicModifierName()
    return "modifier_kings_guard"
end

function item_kings_guard:GetAOERadius()
    return 1200
end
------------

function modifier_kings_guard:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, --GetModifierBonusStats_Strength
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, --GetModifierBonusStats_Agility
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS, --GetModifierBonusStats_Intellect
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,--GetModifierAttackSpeedBonus_Constant
        MODIFIER_PROPERTY_HEALTH_BONUS, --GetModifierHealthBonus
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --GetModifierPhysicalArmorBonus
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        
    }

    return funcs
end

function modifier_kings_guard:OnCreated()
    local ability = self:GetAbility()
    
    if ability and not ability:IsNull() then
        self.allStats = self:GetAbility():GetLevelSpecialValueFor("bonus_all_stats", (self:GetAbility():GetLevel() - 1))
        self.maxHpRegen = self:GetAbility():GetLevelSpecialValueFor("max_hp_regen", (self:GetAbility():GetLevel() - 1))
        self.bonusAttackSpeed = self:GetAbility():GetLevelSpecialValueFor("bonus_attack_speed", (self:GetAbility():GetLevel() - 1))
        self.bonusHealth = self:GetAbility():GetLevelSpecialValueFor("bonus_health", (self:GetAbility():GetLevel() - 1))
        self.bonusArmor = self:GetAbility():GetLevelSpecialValueFor("bonus_armor", (self:GetAbility():GetLevel() - 1))
    end

    self.caster = self:GetCaster()
    self.aura_modifier_name = "modifier_kings_guard_aura"
    self.allyAura = "modifier_kings_guard_aura"
    self.enemyAura = "modifier_kings_guard_aura_enemy"

    if IsServer() then
        --self:StartIntervalThink(0.1)
    end
end

function modifier_kings_guard:OnIntervalThink()
    local caster = self:GetCaster()

    if caster:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_STRENGTH then
        caster:DropItemAtPositionImmediate(self:GetAbility(), caster:GetAbsOrigin())
        DisplayError(caster:GetPlayerID(), "#primary_strength_item")
    end

    self:StartIntervalThink(-1)
end

function modifier_kings_guard:IsAura()
  return true
end

function modifier_kings_guard:GetAuraSearchType()
  return bit.bor(DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_BUILDING)
end

function modifier_kings_guard:GetAuraSearchTeam()
  return bit.bor(DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_TEAM_ENEMY)
end

function modifier_kings_guard:GetAuraRadius()
  return 1200
end

function modifier_kings_guard:GetModifierAura()
    return self.aura_modifier_name
end

function modifier_kings_guard:GetAuraSearchFlags()
  return bit.bor(DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
end

function modifier_kings_guard:GetAuraEntityReject(target)
    if target:GetTeamNumber() == self.caster:GetTeamNumber() then
        self.aura_modifier_name = self.allyAura
    else
        self.aura_modifier_name = self.enemyAura
    end

    return false
end
----------
function modifier_kings_guard_aura:OnCreated()
    local ability = self:GetAbility()
    
    if ability and not ability:IsNull() then
        self.armor = self:GetAbility():GetLevelSpecialValueFor("aura_bonus_armor", (self:GetAbility():GetLevel() - 1))
        self.attackSpeed = self:GetAbility():GetLevelSpecialValueFor("aura_attack_speed", (self:GetAbility():GetLevel() - 1))
    end
end

function modifier_kings_guard_aura:IsDebuff()
    return false
end

function modifier_kings_guard_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, --GetModifierAttackSpeedBonus_Constant
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --GetModifierPhysicalArmorBonus
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, --GetModifierIncomingDamage_Percentage
        
    }

    return funcs
end

function modifier_kings_guard_aura:GetModifierIncomingDamage_Percentage()
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

    return self:GetAbility():GetSpecialValueFor("aura_damage_reduction")
end

function modifier_kings_guard_aura:GetModifierAttackSpeedBonus_Constant()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self.attackSpeed or self:GetAbility():GetLevelSpecialValueFor("aura_attack_speed", (self:GetAbility():GetLevel() - 1))
end

function modifier_kings_guard_aura:GetModifierPhysicalArmorBonus()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self.armor or self:GetAbility():GetLevelSpecialValueFor("aura_bonus_armor", (self:GetAbility():GetLevel() - 1))
end
----------
function modifier_kings_guard_aura_enemy:OnCreated()
    if not self then return end
    self:SetHasCustomTransmitterData(true)
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    local ability = self:GetAbility()

    self.armor = 0
    
    if ability and not ability:IsNull() then
        self.armorReduction = ability:GetLevelSpecialValueFor("aura_armor_reduction", (ability:GetLevel() - 1))
        self.armor = self:GetParent():GetPhysicalArmorValue(false) * (self.armorReduction/100)
        self:InvokeArmorReduction()
    end
end

function modifier_kings_guard_aura_enemy:OnRefresh()
    self:GetParent():RemoveModifierByName("modifier_kings_guard_aura_enemy")
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kings_guard_aura_enemy", {})
end

function modifier_kings_guard_aura_enemy:AddCustomTransmitterData()
    return
    {
        armor = self.fArmor,
    }
end

function modifier_kings_guard_aura_enemy:HandleCustomTransmitterData(data)
    if data.armor ~= nil then
        self.fArmor = tonumber(data.armor)
    end
end

function modifier_kings_guard_aura_enemy:InvokeArmorReduction()
    if IsServer() == true then
        self.fArmor = self.armor

        self:SendBuffRefreshToClients()
    end
end

function modifier_kings_guard_aura_enemy:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --GetModifierPhysicalArmorBonus
    }

    return funcs
end

function modifier_kings_guard_aura_enemy:GetModifierPhysicalArmorBonus()
    return self.fArmor
end

function modifier_kings_guard_aura_enemy:IsDebuff()
    return true
end
----------

function modifier_kings_guard:GetModifierHealthRegenPercentage()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self.maxHpRegen or self:GetAbility():GetLevelSpecialValueFor("max_hp_regen", (self:GetAbility():GetLevel() - 1))
end

function modifier_kings_guard:GetModifierBonusStats_Strength()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self.allStats or self:GetAbility():GetLevelSpecialValueFor("bonus_all_stats", (self:GetAbility():GetLevel() - 1))
end

function modifier_kings_guard:GetModifierBonusStats_Agility()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self.allStats or self:GetAbility():GetLevelSpecialValueFor("bonus_all_stats", (self:GetAbility():GetLevel() - 1))
end

function modifier_kings_guard:GetModifierBonusStats_Intellect()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self.allStats or self:GetAbility():GetLevelSpecialValueFor("bonus_all_stats", (self:GetAbility():GetLevel() - 1))
end

function modifier_kings_guard:GetModifierAttackSpeedBonus_Constant()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self.bonusAttackSpeed or self:GetAbility():GetLevelSpecialValueFor("bonus_attack_speed", (self:GetAbility():GetLevel() - 1))
end

function modifier_kings_guard:GetModifierHealthBonus()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self.bonusHealth or self:GetAbility():GetLevelSpecialValueFor("bonus_health", (self:GetAbility():GetLevel() - 1))
end

function modifier_kings_guard:GetModifierPhysicalArmorBonus()
    if not self then return end
    if not self:GetAbility() or self:GetAbility():IsNull() then return end
    return self.bonusArmor or self:GetAbility():GetLevelSpecialValueFor("bonus_armor", (self:GetAbility():GetLevel() - 1))
end

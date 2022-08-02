LinkLuaModifier("modifier_int_scaling", "modifiers/modifier_int_scaling.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_max_movement_speed", "modifiers/modifier_max_movement_speed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_int_scaling_int", "modifiers/modifier_int_scaling.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_int_scaling_str", "modifiers/modifier_int_scaling.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_int_scaling_agi", "modifiers/modifier_int_scaling.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
}

int_scaling = class(ItemBaseClass)
modifier_int_scaling = class(int_scaling)
modifier_int_scaling_int = class(ItemBaseClass)
modifier_int_scaling_str = class(ItemBaseClass)
modifier_int_scaling_agi = class(ItemBaseClass)

function modifier_int_scaling_agi:GetTexture() return "agi" end
function modifier_int_scaling_int:GetTexture() return "int" end
function modifier_int_scaling_str:GetTexture() return "str" end
-----------------
function int_scaling:GetIntrinsicModifierName()
    return "modifier_int_scaling"
end
-----------------
LOST_ITEMS = {
    ["item_kings_guard_7"] = true,
    ["item_mercure7"] = true,
    ["item_rebels_sword"] = true,
    ["item_octarine_core6"] = true,
    ["item_trident_custom_6"] = true,
    ["item_veil_of_discord6"] = true,
}

function IsItemException(item)
    return LOST_ITEMS[item:GetName()]
end

function modifier_int_scaling:OnCreated(params)
    if not IsServer() then return end

    local caster = self:GetCaster()

    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_max_movement_speed", {})

    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_int_scaling_int", {})
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_int_scaling_agi", {})
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_int_scaling_str", {})
end

function modifier_int_scaling:IsHidden() return true end

function modifier_int_scaling:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, --GetModifierMagicalResistanceBonus
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, --GetModifierMoveSpeedBonus_Constant (flat)
    }

    return funcs
end

function modifier_int_scaling:CheckState()
    local state = {
        --[MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
    return state
end
--
function modifier_int_scaling_int:OnCreated()
    self:SetHasCustomTransmitterData(true)

    self:OnRefresh()

    if not IsServer() then return end

    self:StartIntervalThink(1)
end

function modifier_int_scaling_int:OnIntervalThink()
    self:OnRefresh()
end

function modifier_int_scaling_int:OnRefresh()
    if not IsServer() then return end

    local caster = self:GetCaster()

    local bonusSpellAmp = caster:GetBaseIntellect() * 0.05

    if bonusSpellAmp > 5000 then
        bonusSpellAmp = 5000
    end

    self.stats = bonusSpellAmp

    self:InvokeAttributeBonus()
end

function modifier_int_scaling_int:AddCustomTransmitterData()
    return
    {
        stats = self.fStats,
    }
end

function modifier_int_scaling_int:HandleCustomTransmitterData(data)
    if data.stats ~= nil then
        self.fStats = tonumber(data.stats)
    end
end

function modifier_int_scaling_int:InvokeAttributeBonus()
    if IsServer() == true then
        self.fStats = self.stats

        self:SendBuffRefreshToClients()
    end
end

function modifier_int_scaling_int:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, --GetModifierSpellAmplify_Percentage
    }

    return funcs
end

function modifier_int_scaling_int:GetModifierSpellAmplify_Percentage()
    return self.fStats
end

---------------------------------
function modifier_int_scaling_str:OnCreated()
    self:SetHasCustomTransmitterData(true)

    self:OnRefresh()

    if not IsServer() then return end

    self:StartIntervalThink(1)
end

function modifier_int_scaling_str:OnIntervalThink()
    self:OnRefresh()
end

function modifier_int_scaling_str:OnRefresh()
    if not IsServer() then return end

    local caster = self:GetCaster()

    local bonusArmor = caster:GetBaseStrength() * 0.225
    if bonusArmor > 5000 then
        bonusArmor = 5000
    end

    self.stats = bonusArmor

    self:InvokeAttributeBonus()
end

function modifier_int_scaling_str:AddCustomTransmitterData()
    return
    {
        stats = self.fStats,
    }
end

function modifier_int_scaling_str:HandleCustomTransmitterData(data)
    if data.stats ~= nil then
        self.fStats = tonumber(data.stats)
    end
end

function modifier_int_scaling_str:InvokeAttributeBonus()
    if IsServer() == true then
        self.fStats = self.stats

        self:SendBuffRefreshToClients()
    end
end

function modifier_int_scaling_str:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --GetModifierPhysicalArmorBonus (flat)
    }

    return funcs
end

function modifier_int_scaling_str:GetModifierPhysicalArmorBonus(event)
    return self.fStats
end

-----------------
function modifier_int_scaling_agi:OnCreated()
    self:SetHasCustomTransmitterData(true)

    self:OnRefresh()
    
    if not IsServer() then return end

    self:StartIntervalThink(1)
end

function modifier_int_scaling_agi:OnIntervalThink()
    self:OnRefresh()
end

function modifier_int_scaling_agi:OnRefresh()
    if not IsServer() then return end

    local caster = self:GetCaster()

    local bonusOutgoing = caster:GetBaseAgility() * 1.5
    if bonusOutgoing > 750000 then
        bonusOutgoing = 750000
    end

    self.stats = bonusOutgoing

    self:InvokeAttributeBonus()
end

function modifier_int_scaling_agi:AddCustomTransmitterData()
    return
    {
        stats = self.fStats,
    }
end

function modifier_int_scaling_agi:HandleCustomTransmitterData(data)
    if data.stats ~= nil then
        self.fStats = tonumber(data.stats)
    end
end

function modifier_int_scaling_agi:InvokeAttributeBonus()
    if IsServer() == true then
        self.fStats = self.stats

        self:SendBuffRefreshToClients()
    end
end

function modifier_int_scaling_agi:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, --GetModifierBaseAttack_BonusDamage
    }

    return funcs
end


function modifier_int_scaling_agi:GetModifierBaseAttack_BonusDamage()
    return self.fStats
end
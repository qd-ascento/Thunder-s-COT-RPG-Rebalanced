LinkLuaModifier("modifier_bristleback_warpath_custom", "heroes/hero_bristleback/warpath.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_warpath_custom_stacks", "heroes/hero_bristleback/warpath.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseStacks = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return true end,
    IsDebuff = function(self) return false end,
}

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

bristleback_warpath_custom = class(ItemBaseClass)
modifier_bristleback_warpath_custom = class(bristleback_warpath_custom)
modifier_bristleback_warpath_custom_stacks = class(ItemBaseStacks)

function modifier_bristleback_warpath_custom_stacks:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bristleback_warpath_custom_stacks:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE   , --GetModifierPreAttack_BonusDamage
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE 
    }
    return funcs
end

function modifier_bristleback_warpath_custom_stacks:OnTooltip()
    return ((self:GetAbility():GetSpecialValueFor("damage_per_stack") + self.fDamage) * self:GetStackCount())
end

function modifier_bristleback_warpath_custom_stacks:GetModifierPreAttack_BonusDamage()
    return ((self:GetAbility():GetSpecialValueFor("damage_per_stack") + self.fDamage) * self:GetStackCount())
end

function modifier_bristleback_warpath_custom_stacks:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("move_speed_per_stack") * self:GetStackCount()
end

function modifier_bristleback_warpath_custom_stacks:GetModifierModelScale()
    return self:GetStackCount()
end

function modifier_bristleback_warpath_custom_stacks:OnCreated()
    self.damage = 0
    self:SetHasCustomTransmitterData(true)
    self:OnRefresh()
end

function modifier_bristleback_warpath_custom_stacks:OnRefresh()
    if not IsServer() then return end

    self.damage = self:GetCaster():GetStrength() * (self:GetAbility():GetSpecialValueFor("str_damage_pct_per_stack")/100)

    self:InvokeBonusDamage()
end

function modifier_bristleback_warpath_custom_stacks:AddCustomTransmitterData()
    return
    {
        damage = self.fDamage,
    }
end

function modifier_bristleback_warpath_custom_stacks:HandleCustomTransmitterData(data)
    if data.damage ~= nil then
        self.fDamage = tonumber(data.damage)
    end
end

function modifier_bristleback_warpath_custom_stacks:InvokeBonusDamage()
    if IsServer() == true then
        self.fDamage = self.damage

        self:SendBuffRefreshToClients()
    end
end
-------------
function bristleback_warpath_custom:GetIntrinsicModifierName()
    return "modifier_bristleback_warpath_custom"
end

function bristleback_warpath_custom:GetBehavior()
    local caster = self:GetCaster()

    if caster:HasScepter() then
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
    else
        return DOTA_ABILITY_BEHAVIOR_PASSIVE 
    end
end

function bristleback_warpath_custom:GetCooldown(level)
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor("cooldown_scepter")
    end

    return self.BaseClass.GetCooldown(self, level)
end

function bristleback_warpath_custom:OnSpellStart()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local mod = caster:FindModifierByNameAndCaster("modifier_bristleback_warpath_custom_stacks", caster)

    if mod == nil then
        mod = caster:AddNewModifier(caster, self, "modifier_bristleback_warpath_custom_stacks", {
            duration = self:GetAbility():GetSpecialValueFor("stack_duration")
        })
    end

    mod:SetStackCount(self:GetSpecialValueFor("max_stacks"))
end

function modifier_bristleback_warpath_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST  
    }
    return funcs
end

function modifier_bristleback_warpath_custom:OnCreated()
    self.parent = self:GetParent()
end

function modifier_bristleback_warpath_custom:OnAbilityFullyCast(event)
    local parent = self:GetParent()

    if event.unit ~= parent then
        return
    end

    local ability = event.ability

    local _ability = parent:FindAbilityByName(ability:GetAbilityName())
    if _ability == nil or _ability:IsNull() then return end

    if parent:HasModifier("modifier_bristleback_warpath_custom_stacks") then
        local mod = parent:FindModifierByName("modifier_bristleback_warpath_custom_stacks")
        if mod:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_stacks") then
            mod:IncrementStackCount()
        end

        mod:ForceRefresh()
    else
        local mod = parent:AddNewModifier(parent, self:GetAbility(), "modifier_bristleback_warpath_custom_stacks", {
            duration = self:GetAbility():GetSpecialValueFor("stack_duration")
        })
        mod:IncrementStackCount()
        mod:ForceRefresh()
    end
end

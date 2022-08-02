LinkLuaModifier("modifier_pudge_flesh_heap_custom", "heroes/hero_pudge/heap.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pudge_flesh_heap_custom_buff_permanent", "heroes/hero_pudge/heap.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}
local ItemBaseClassBuff = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return true end,
    IsDebuff = function(self) return false end,
}


pudge_flesh_heap_custom = class(ItemBaseClass)
modifier_pudge_flesh_heap_custom = class(pudge_flesh_heap_custom)
modifier_pudge_flesh_heap_custom_buff_permanent = class(ItemBaseClassBuff)
-------------
function modifier_pudge_flesh_heap_custom_buff_permanent:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_pudge_flesh_heap_custom_buff_permanent:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS , --GetModifierBonusStats_Strength
    }

    return funcs
end

function modifier_pudge_flesh_heap_custom_buff_permanent:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("str_gain") * self:GetStackCount()
end
-------------
function pudge_flesh_heap_custom:GetIntrinsicModifierName()
    return "modifier_pudge_flesh_heap_custom"
end


function modifier_pudge_flesh_heap_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
    }
    return funcs
end

function modifier_pudge_flesh_heap_custom:GetModifierTotal_ConstantBlock()
    if not self:GetParent():HasModifier("modifier_item_aghanims_shard") then return 0 end

    return (self:GetParent():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("damage_block_from_hp")/100))
end

function modifier_pudge_flesh_heap_custom:OnCreated()
    self.parent = self:GetParent()
end

function modifier_pudge_flesh_heap_custom:OnDeath(event)
    local unit = event.attacker
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local victim = event.unit

    if unit ~= parent then
        return
    end

    local ability = self:GetAbility()

    local buff = unit:FindModifierByNameAndCaster("modifier_pudge_flesh_heap_custom_buff_permanent", unit)
    local stacks = unit:GetModifierStackCount("modifier_pudge_flesh_heap_custom_buff_permanent", unit)
    
    if not buff then
        buff = unit:AddNewModifier(unit, ability, "modifier_pudge_flesh_heap_custom_buff_permanent", {})
    else
        buff:ForceRefresh()
    end

    if buff ~= nil then
        local preTotal = unit:GetStrength() + (buff:GetStackCount() * ability:GetSpecialValueFor("str_gain"))
        if preTotal > 10000000 then return false end
    end

    unit:SetModifierStackCount("modifier_pudge_flesh_heap_custom_buff_permanent", unit, (stacks + 1))
end
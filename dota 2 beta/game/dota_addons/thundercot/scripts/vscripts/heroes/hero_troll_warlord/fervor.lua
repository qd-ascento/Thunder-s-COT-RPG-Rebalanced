fervor_custom = class({})

LinkLuaModifier("modifier_fervor_custom", 'heroes/hero_troll_warlord/fervor.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fervor_custom_effect", 'heroes/hero_troll_warlord/fervor.lua', LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function fervor_custom:GetIntrinsicModifierName()
    return "modifier_fervor_custom"
end

modifier_fervor_custom = class({})

-----------------------------------------------------------------------------
function modifier_fervor_custom:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_fervor_custom:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_fervor_custom:OnCreated(kv)
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.target = nil
end

-------------------------------------------------------------------------------
function modifier_fervor_custom:OnRefresh(kv)
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

-------------------------------------------------------------------------------
function modifier_fervor_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    }
    return funcs
end

-------------------------------------------------------------------------------
function modifier_fervor_custom:GetModifierProcAttack_Feedback(params)
    local parent = self:GetParent()
    if not parent or parent:PassivesDisabled() then return end
    if not IsServer() then return end
    
    if parent:IsIllusion() then return end
    if params.target:GetUnitName() == "npc_dota_creature_target_dummy" then return false end

    parent:AddNewModifier(parent, self:GetAbility(), "modifier_fervor_custom_effect", {})
    local stack_count = params.attacker:GetModifierStackCount("modifier_fervor_custom_effect", parent)
    self:SetStacksCustom(stack_count + 1)
    --[[
    if self.target == params.target then
        self:SetStacksCustom(stack_count + 1)
    else
        self:SetStacksCustom(1)
    end
    self.target = params.target
    --]]
end

-------------------------------------------------------------------------------
function modifier_fervor_custom:SetStacksCustom(value)
    local attacker = self:GetParent()
    attacker:SetModifierStackCount("modifier_fervor_custom_effect", attacker, value)
end

modifier_fervor_custom_effect = class({})

--------------------------------------------------------------------------------

function modifier_fervor_custom_effect:IsHidden()
    return false
end

--------------------------------------------------------------------------------

function modifier_fervor_custom_effect:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
function modifier_fervor_custom_effect:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_fervor_custom_effect:IsDebuff()
    return false
end

function modifier_fervor_custom_effect:RemoveOnDeath()
    return false
end

--------------------------------------------------------------------------------

function modifier_fervor_custom_effect:OnCreated( kv )
    self:SetHasCustomTransmitterData(true)
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
    self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )

    if not IsServer() then return end
    --self:GetCaster():GetTalentSpecialValueFor("special_bonus_unique_troll_warlord_5")
    self.attack_speed_by_talent = 0
    self:InvokeBonusAttackSpeed()
end

function modifier_fervor_custom_effect:AddCustomTransmitterData()
    return
    {
        attack_speed_by_talent = self.fAttack_speed_by_talent,
    }
end

function modifier_fervor_custom_effect:HandleCustomTransmitterData(data)
    if data.attack_speed_by_talent ~= nil then
        self.fAttack_speed_by_talent = tonumber(data.attack_speed_by_talent)
    end
end

function modifier_fervor_custom_effect:InvokeBonusAttackSpeed()
    if IsServer() == true then
        self.fAttack_speed_by_talent = self.attack_speed_by_talent

        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------
function modifier_fervor_custom_effect:OnRefresh(kv)
    self:OnCreated(kv)
end
-------------------------------------------------------------------------------

function modifier_fervor_custom_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_fervor_custom_effect:GetModifierPreAttack_BonusDamage( params )
    return self.damage * self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_fervor_custom_effect:GetModifierAttackSpeedBonus_Constant( params )
    return (self.attack_speed + self.fAttack_speed_by_talent) * self:GetStackCount()
end

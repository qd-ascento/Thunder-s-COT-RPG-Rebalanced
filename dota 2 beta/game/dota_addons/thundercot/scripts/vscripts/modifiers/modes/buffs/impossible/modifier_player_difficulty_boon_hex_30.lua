LinkLuaModifier("modifier_player_difficulty_boon_hex_30", "modifiers/modes/buffs/impossible/modifier_player_difficulty_boon_hex_30.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_hex_30_hexed", "modifiers/modes/buffs/impossible/modifier_player_difficulty_boon_hex_30.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return true end,
}

player_difficulty_boon_hex_30 = class({
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
})

modifier_player_difficulty_boon_hex_30_hexed = class({
    IsPurgable = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsDebuff = function(self) return true end,
})

modifier_player_difficulty_boon_hex_30 = class(ItemBaseClass)

function player_difficulty_boon_hex_30:GetIntrinsicModifierName()
    return "modifier_player_difficulty_boon_hex_30"
end

function modifier_player_difficulty_boon_hex_30:GetTexture() return "sheep" end
function modifier_player_difficulty_boon_hex_30_hexed:GetTexture() return "sheep" end

function modifier_player_difficulty_boon_hex_30:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_player_difficulty_boon_hex_30:OnCreated()
    if not IsServer() then return end
    self.cooldown = false
end

function modifier_player_difficulty_boon_hex_30:OnTakeDamage(event)
    if not IsServer() then return end
    if event.attacker ~= self:GetParent() then return end
    if event.attacker == self:GetParent() and event.unit == self:GetParent() then return end
    if event.damage_type ~= DAMAGE_TYPE_MAGICAL and event.damage_type ~= DAMAGE_TYPE_PURE then return end
    if event.attacker:IsMagicImmune() or event.attacker:IsInvulnerable() then return end
    if self.cooldown then return end
    if not RollPercentage(20) then return end

    local parent = self:GetParent()
    
    parent:AddNewModifier(parent, nil, "modifier_player_difficulty_boon_hex_30_hexed", {
        duration = 1
    })

    EmitSoundOn("Hero_ShadowShaman.SheepHex.Target", parent)

    self.cooldown = true
    Timers:CreateTimer(10.0, function()
        self.cooldown = false
    end)
end
-------------
function modifier_player_difficulty_boon_hex_30_hexed:CheckState()
    local state = {
        [MODIFIER_STATE_HEXED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true
    }
    return state
end

function modifier_player_difficulty_boon_hex_30_hexed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT 
    }
    return funcs
end

function modifier_player_difficulty_boon_hex_30_hexed:GetModifierModelChange()
    return "models/items/hex/sheep_hex/sheep_hex.vmdl"
end

function modifier_player_difficulty_boon_hex_30_hexed:GetModifierMoveSpeed_Limit()
    return 100
end
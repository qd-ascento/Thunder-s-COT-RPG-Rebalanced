LinkLuaModifier("modifier_player_difficulty_boon_disarm_30", "modifiers/modes/buffs/impossible/modifier_player_difficulty_boon_disarm_30.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_player_difficulty_boon_disarm_30_disarmed", "modifiers/modes/buffs/impossible/modifier_player_difficulty_boon_disarm_30.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return true end,
}

player_difficulty_boon_disarm_30 = class({
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
})

modifier_player_difficulty_boon_disarm_30_disarmed = class({
    IsPurgable = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsDebuff = function(self) return true end,
})

modifier_player_difficulty_boon_disarm_30 = class(ItemBaseClass)

function player_difficulty_boon_disarm_30:GetIntrinsicModifierName()
    return "modifier_player_difficulty_boon_disarm_30"
end

function modifier_player_difficulty_boon_disarm_30:GetTexture() return "disarm" end
function modifier_player_difficulty_boon_disarm_30_disarmed:GetTexture() return "disarm" end

function modifier_player_difficulty_boon_disarm_30:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
    }

    return funcs
end

function modifier_player_difficulty_boon_disarm_30:OnCreated()
    if not IsServer() then return end
    self.cooldown = false
end

function modifier_player_difficulty_boon_disarm_30:OnAttack(event)
    if not IsServer() then return end
    if event.attacker ~= self:GetParent() then return end
    if event.attacker:IsMagicImmune() or event.attacker:IsInvulnerable() then return end
    if self.cooldown then return end
    if not RollPercentage(20) then return end

    local parent = self:GetParent()
    
    parent:AddNewModifier(parent, nil, "modifier_player_difficulty_boon_disarm_30_disarmed", {
        duration = 1
    })

    EmitSoundOn("Hero_Pangolier.LuckyShot.Proc", parent)

    self.cooldown = true
    Timers:CreateTimer(10.0, function()
        self.cooldown = false
    end)
end
-------------
function modifier_player_difficulty_boon_disarm_30_disarmed:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true
    }
    return state
end

function modifier_player_difficulty_boon_disarm_30_disarmed:GetStatusEffectName()
    return "particles/generic_gameplay/generic_disarm.vpcf"
end
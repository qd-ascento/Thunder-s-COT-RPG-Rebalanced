LinkLuaModifier("modifier_enemy_difficulty_buff_mana_burn_5", "modifiers/modes/buffs/unfair/modifier_enemy_difficulty_buff_mana_burn_5.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return true end,
}

enemy_difficulty_buff_mana_burn_5 = class({
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
})

modifier_enemy_difficulty_buff_mana_burn_5 = class(ItemBaseClass)


function enemy_difficulty_buff_mana_burn_5:GetIntrinsicModifierName()
    return "modifier_enemy_difficulty_buff_mana_burn_5"
end

function modifier_enemy_difficulty_buff_mana_burn_5:GetTexture() return "manaburn" end
-------------
function modifier_enemy_difficulty_buff_mana_burn_5:OnCreated()
    if not IsServer() then return end
end

function modifier_enemy_difficulty_buff_mana_burn_5:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_enemy_difficulty_buff_mana_burn_5:OnAttackLanded(event)
    if not IsServer() then return end

    if event.attacker ~= self:GetParent() then return end
    if event.target:IsMagicImmune() or event.target:IsInvulnerable() then return end
        
    local burn = event.target:GetMaxMana() * 0.02
    event.target:SpendMana(burn, self:GetAbility())

    ApplyDamage({
        victim = event.target,
        attacker = event.attacker,
        damage = burn,
        damage_type = DAMAGE_TYPE_MAGICAL,
    })

    local effect_cast = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN, event.target)
    ParticleManager:ReleaseParticleIndex(effect_cast)
    EmitSoundOn("Hero_Antimage.ManaBreak", event.target)
end
---
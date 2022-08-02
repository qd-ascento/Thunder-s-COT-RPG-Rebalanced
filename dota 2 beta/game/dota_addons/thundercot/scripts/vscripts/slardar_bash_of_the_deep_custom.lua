LinkLuaModifier("modifier_slardar_bash_of_the_deep_custom", "slardar_bash_of_the_deep_custom.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

slardar_bash_of_the_deep_custom = class(ItemBaseClass)
modifier_slardar_bash_of_the_deep_custom = class(slardar_bash_of_the_deep_custom)
-------------
function slardar_bash_of_the_deep_custom:GetIntrinsicModifierName()
    return "modifier_slardar_bash_of_the_deep_custom"
end


function modifier_slardar_bash_of_the_deep_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED 
    }
    return funcs
end

function modifier_slardar_bash_of_the_deep_custom:OnCreated()
    self.parent = self:GetParent()
end

function modifier_slardar_bash_of_the_deep_custom:OnAttackLanded(event)
    local unit = event.attacker
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local victim = event.target

    if unit ~= parent then
        return
    end

    if event.damage_type ~= DAMAGE_TYPE_PHYSICAL or event.inflictor ~= nil or event.fail_type ~= DOTA_ATTACK_RECORD_FAIL_NO or event.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK or not caster:IsAlive() or caster:PassivesDisabled() or victim:IsMagicImmune() or not ability:IsCooldownReady() then
        return
    end
    
    local chance = ability:GetLevelSpecialValueFor("chance", (ability:GetLevel() - 1))

    if not RollPercentage(chance) then
        return
    end

    local crush = unit:FindAbilityByName("slardar_slithereen_crush")
    local corrosive = unit:FindAbilityByName("slardar_amplify_damage")

    if crush ~= nil and crush:GetLevel() > 0 and crush:IsCooldownReady() then
        unit:CastAbilityImmediately(crush, -1)
        
        if corrosive ~= nil and corrosive:GetLevel() > 0 then
            victim:AddNewModifier(unit, corrosive, "modifier_slardar_amplify_damage", { duration = corrosive:GetSpecialValueFor("duration") })
        end

        ability:UseResources(false, false, true) 
    end
end
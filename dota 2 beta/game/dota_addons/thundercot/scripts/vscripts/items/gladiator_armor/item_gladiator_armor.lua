LinkLuaModifier("modifier_item_gladiator_armor", "items/gladiator_armor/item_gladiator_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_gladiator_armor_enrage", "items/gladiator_armor/item_gladiator_armor.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassEnrage = {
    IsPurgable = function(self) return true end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return false end,
}

item_gladiator_armor = class(ItemBaseClass)
item_gladiator_armor_2 = item_gladiator_armor
item_gladiator_armor_3 = item_gladiator_armor
item_gladiator_armor_4 = item_gladiator_armor
item_gladiator_armor_5 = item_gladiator_armor
item_gladiator_armor_6 = item_gladiator_armor
modifier_item_gladiator_armor = class(item_gladiator_armor)
modifier_item_gladiator_armor_enrage = class(ItemBaseClassEnrage)

function modifier_item_gladiator_armor:GetTexture() return "gladiator_armor" end
function modifier_item_gladiator_armor_enrage:GetTexture() return "gladiator_armor" end
-------------
function item_gladiator_armor:GetIntrinsicModifierName()
    return "modifier_item_gladiator_armor"
end

function modifier_item_gladiator_armor:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, --GetModifierPreAttack_BonusDamage
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, --GetModifierPhysicalArmorBonus
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, --GetModifierIncomingDamage_Percentage
    }
    return funcs
end

function modifier_item_gladiator_armor:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_gladiator_armor:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_gladiator_armor:GetModifierIncomingDamage_Percentage()
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

    return self:GetAbility():GetSpecialValueFor("damage_res_pct")
end

function modifier_item_gladiator_armor:OnAttackLanded(event)
    local attacker = event.attacker
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local victim = event.target

    if victim ~= parent then
        return
    end

    if attacker == victim then return end

    if event.damage_type ~= DAMAGE_TYPE_PHYSICAL or event.inflictor ~= nil or event.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK or not victim:IsAlive() or victim:IsMuted() then
        return
    end

    -- reflects a portion of your strength and a portion of the damage taken back to the attacker as the same damage type --

    local ability = self:GetAbility()
    local strengthDamage = victim:GetStrength() * (ability:GetSpecialValueFor("strength_ret")/100)
    local damageReturned = event.original_damage * (ability:GetSpecialValueFor("pct_ret")/100)

    -- Will return strength damage to bosses --
    ApplyDamage({
        victim = attacker, 
        attacker = victim, 
        damage = strengthDamage, 
        damage_type = event.damage_type,
        damage_flags = bit.bor(DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, DOTA_DAMAGE_FLAG_REFLECTION),
    })

    -- Will not return damage taken back to bosses --
    if (IsCreepTCOTRPG(attacker)) and (victim:GetLevel() >= attacker:GetLevel()) then
        ApplyDamage({
            victim = attacker, 
            attacker = victim, 
            damage = damageReturned, 
            damage_type = event.damage_type,
            damage_flags = bit.bor(DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, DOTA_DAMAGE_FLAG_REFLECTION),
        })
    end

    -- applies an enrage effect when the attacker hits you --

    local enrage = attacker:FindModifierByNameAndCaster("modifier_item_gladiator_armor_enrage", victim)
    if enrage == nil then
        enrage = attacker:AddNewModifier(victim, ability, "modifier_item_gladiator_armor_enrage", {
            duration = ability:GetSpecialValueFor("duration")
        })
    end

    if enrage == nil or not enrage then return end

    enrage:ForceRefresh()
end
--------
function modifier_item_gladiator_armor_enrage:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT , --GetModifierAttackSpeedBonus_Constant
    }
    return funcs
end

function modifier_item_gladiator_armor_enrage:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("enrage_atk_spd")
end
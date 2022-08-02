LinkLuaModifier("modifier_padla_opyt", "heroes/hero_padla/opyt.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_padla_opyt_aura", "heroes/hero_padla/opyt.lua", LUA_MODIFIER_MOTION_NONE)


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

padla_opyt = class(ItemBaseClass)
modifier_padla_opyt = class(padla_opyt)

modifier_padla_opyt_aura = class(ItemBaseClassAura)

function modifier_padla_opyt_aura:GetTexture() return "padla/opyt" end

function padla_opyt:GetIntrinsicModifierName()
    return "modifier_padla_opyt"
end

function padla_opyt:GetAOERadius()
    return 1250
end
-------------

function modifier_padla_opyt:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
    self.casterName = self.caster:GetName()
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.aura_modifier_name = "modifier_padla_opyt_aura"
    
    if self.ability and not self.ability:IsNull() then
	    self.bonus_gold = self:GetAbility():GetLevelSpecialValueFor("bonus_gold", (self:GetAbility():GetLevel() - 1))
	    self.bonus_xp = self:GetAbility():GetLevelSpecialValueFor("bonus_xp", (self:GetAbility():GetLevel() - 1))
    end
end

function modifier_padla_opyt:IsAura()
  return true
end

function modifier_padla_opyt:GetAuraSearchType()
  return self:GetAbility():GetAbilityTargetType()
end

function modifier_padla_opyt:GetAuraSearchTeam()
  return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_padla_opyt:GetAuraRadius()
    return 1250
end

function modifier_padla_opyt:GetModifierAura()
    return self.aura_modifier_name
end

function modifier_padla_opyt:GetAuraSearchFlags()
  return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_padla_opyt:GetAuraEntityReject(target)
    self.aura_modifier_name = self.aura_modifier_name

    return false
end

----------
function modifier_padla_opyt_aura:OnCreated()
    self.ability = self:GetAbility()
	self.caster = self:GetCaster()
    self.casterName = self.caster:GetName()
    
    if self.ability and not self.ability:IsNull() then
	    self.bonus_gold = self:GetAbility():GetLevelSpecialValueFor("bonus_gold", (self:GetAbility():GetLevel() - 1))
	    self.bonus_xp = self:GetAbility():GetLevelSpecialValueFor("bonus_xp", (self:GetAbility():GetLevel() - 1))
    end
end

function modifier_padla_opyt_aura:IsDebuff()
	if self.casterName == "npc_dota_hero_riki" then
	    return false
	else
		return true
	end
end

function modifier_padla_opyt_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXP_RATE_BOOST,
		MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end


function modifier_padla_opyt_aura:GetModifierPercentageExpRateBoost()
	local bonus_xp = self.bonus_xp
	if self.casterName ~= "npc_dota_hero_riki" then
		bonus_xp = bonus_xp * -1
	end
	print(self.casterName .. " Отладка получает опыт: " .. bonus_xp)
		return bonus_xp
end


function modifier_padla_opyt_aura:OnDeath(data)
    local caster = self:GetCaster()
	local parent = self:GetParent()
	local attacker = data.attacker
	local unit = data.unit
    local ability = self:GetAbility()
	local share_gold = (self.bonus_gold/100)

	print("Отладка caster: " .. caster)
	print("Отладка parent: " .. caster)

    if parent == attacker then
			local gold = unit:GetGoldBounty()*share_gold
			local player = PlayerResource:GetPlayer(caster:GetPlayerID())

			if caster:GetName() ~= "npc_dota_hero_riki" then
				gold = gold * -1
			end
			print(caster:GetName() .. "Отладка получает золото: " .. gold)
			SendOverheadEventMessage( player, OVERHEAD_ALERT_GOLD, caster, gold, nil )
			caster:ModifyGold(gold, false, 0)
   end
end








LinkLuaModifier("modifier_effect_private", "modules/effects/player/private", LUA_MODIFIER_MOTION_NONE)
if not modifier_effect_private then modifier_effect_private = class({}) end

PRIVATE_IDS = {
    "76561198016484191",
    "76561198082943320",
    "76561199239767257",
    "76561198846036305",
    "76561199100151253",
    "76561198867602440"
}

function modifier_effect_private:IsHidden()
    return false
end

function modifier_effect_private:GetEffectName()
  return "particles/econ/events/fall_2021/fall_2021_emblem_game_effect.vpcf"
end

function modifier_effect_private:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_effect_private:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_effect_private:GetTexture()
      return "item_ultimate_scepter"
end

function modifier_effect_private:AllowIllusionDuplicate() return true end
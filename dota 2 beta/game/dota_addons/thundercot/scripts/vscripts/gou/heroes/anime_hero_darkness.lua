PseudoRandom = class({})

if not PseudoRandom.RandomInstanceTable then
    PseudoRandom.RandomInstanceTable = {}
end

PseudoRandom.RandomC = {}

for i=1, 100 do
    PseudoRandom.RandomC[i] = nil
end

function PseudoRandom:RollPseudoRandom(Instance, pct)
    if not Instance or pct <= 0 or (type(Instance) ~= "number" and not Instance.entindex) then
        return false
    end
    local hInstance = type(Instance) == "number" and Instance or Instance:entindex()
    PseudoRandom.RandomC[pct] = PseudoRandom.RandomC[pct] or PseudoRandom:CFromP(pct / 100) * 100
    local increase = PseudoRandom.RandomC[pct]
    if not PseudoRandom.RandomInstanceTable[hInstance] then
        PseudoRandom.RandomInstanceTable[hInstance] = increase
        return RollPercentage(PseudoRandom.RandomInstanceTable[hInstance])
    else
        PseudoRandom.RandomInstanceTable[hInstance] = PseudoRandom.RandomInstanceTable[hInstance] + increase
        if RollPercentage(PseudoRandom.RandomInstanceTable[hInstance]) then
            PseudoRandom.RandomInstanceTable[hInstance] = 0
            return true
        else
            return false
        end
    end
end

function PseudoRandom:CFromP(P)
    local Cupper = P
    local Clower = 0
    local Cmid = 0
    
    local p1 = 0
    local p2 = 1
    
    while true do
        Cmid = (Cupper + Clower) / 2;
        p1 = PseudoRandom:PFromC(Cmid)
        if math.abs(p1 - p2) <= 0 then
            break
        end
        
        if p1 > P then
            Cupper = Cmid
        else
            Clower = Cmid
        end
        
        p2 = p1
    end
    
    return Cmid
end

function PseudoRandom:PFromC(C)
    local pOnN = 0
    local pByN = 0
    local sumPByN = 0
    
    local maxFails = math.ceil(1/ C)
    
    for N=1,maxFails do
        pOnN = math.min(1, N * C) * (1 - pByN)
        pByN = pByN + pOnN
        sumPByN = sumPByN + N * pOnN
    end

    return 1/sumPByN
end




local function HasAnimeArcana(parent)
   
    local plevel = 2
    
    
return (plevel >= 1)
end
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
darkness_taunt = class({})

function darkness_taunt:IsStealable()           return true end
function darkness_taunt:IsHiddenWhenStolen()    return false end
function darkness_taunt:GetAbilityTextureName()
    return HasAnimeArcana(self:GetCaster()) 
           and "anime_hero_darkness/darkness_taunt_arcana"
           or self.BaseClass.GetAbilityTextureName(self)
end
function darkness_taunt:GetAOERadius()
    if self:GetCaster():HasScepter() then
        return 450
    else
        return self:GetSpecialValueFor("radius")
    end
end

function darkness_taunt:OnSpellStart()
    local hCaster     = self:GetCaster()
    local iCasterTeam = hCaster:GetTeamNumber()
    local fDuration   = self:GetSpecialValueFor("duration")
    local fRadius     = self:GetAOERadius()
    local hEnemies = FindUnitsInRadius(  
                                        iCasterTeam,
                                        hCaster:GetAbsOrigin(),
                                        nil,
                                        fRadius,
                                        self:GetAbilityTargetTeam(),
                                        self:GetAbilityTargetType(),
                                        self:GetAbilityTargetFlags(),
                                        FIND_ANY_ORDER,
                                        false)

    for _, hEnemy in pairs(hEnemies) do
        if hEnemy ~= nil then
            hEnemy:AddNewModifier(hCaster, self, "modifier_darkness_taunt_debuff", {duration = fDuration})
        end
    end

    local sTauntPFX = HasAnimeArcana(hCaster)
                      and "particles/heroes/anime_hero_darkness/darkness_taunt_arcana.vpcf"
                      or "particles/heroes/anime_hero_darkness/darkness_taunt.vpcf"

    local iTauntPFX =   ParticleManager:CreateParticle( sTauntPFX, PATTACH_ABSORIGIN_FOLLOW, hCaster )
                        ParticleManager:SetParticleControlEnt(
                                                                iTauntPFX,
                                                                1,
                                                                hCaster,
                                                                PATTACH_POINT_FOLLOW,
                                                                "attach_attack1",
                                                                Vector(0,0,0),
                                                                true
                                                            )

                        ParticleManager:SetParticleControl( iTauntPFX, 2, Vector(fRadius, fRadius, fRadius) )
                        ParticleManager:SetParticleControl( iTauntPFX, 60, Vector(255, 238, 0) )
                        ParticleManager:SetParticleControl( iTauntPFX, 61, Vector(255, 238, 0) )
                        ParticleManager:ReleaseParticleIndex( iTauntPFX )

    EmitSoundOn("Darkness.Taunt.Cast.1", hCaster)
end
--------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_darkness_taunt_debuff", "GoU/heroes/anime_hero_darkness", LUA_MODIFIER_MOTION_NONE)

modifier_darkness_taunt_debuff = class({})

function modifier_darkness_taunt_debuff:IsHidden()           return false end
function modifier_darkness_taunt_debuff:IsDebuff()           return true end
function modifier_darkness_taunt_debuff:IsPurgable()         return false end
function modifier_darkness_taunt_debuff:IsPurgeException()   return false end
function modifier_darkness_taunt_debuff:RemoveOnDeath()      return true end
function modifier_darkness_taunt_debuff:CheckState()
    local state =   {
                        [MODIFIER_STATE_TAUNTED]                         = true,
                        [MODIFIER_STATE_COMMAND_RESTRICTED]              = true
                    }
    return state
end
function modifier_darkness_taunt_debuff:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
                    }
    return func
end
function modifier_darkness_taunt_debuff:GetModifierAttackSpeedBonus_Constant(keys)
    return self.fAsBonus
end
function modifier_darkness_taunt_debuff:GetModifierBaseDamageOutgoing_Percentage(keys)
    return self.fDamageReduction
end
function modifier_darkness_taunt_debuff:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    self.fAsBonus         = self.ability:GetSpecialValueFor("as_bonus")
    self.fDamageReduction = self.ability:GetSpecialValueFor("damage_reduction")

    if IsServer() then
        self.parent:Interrupt()
        self.parent:InterruptChannel()

        self:OnIntervalThink()
        self:StartIntervalThink(FrameTime())
    end
end
function modifier_darkness_taunt_debuff:OnIntervalThink()
    if IsServer() then
        if self.caster ~= nil and self.caster:IsAlive() then
            return self.parent:MoveToTargetToAttack(self.caster)
        end
        return self:Destroy()
    end
end
function modifier_darkness_taunt_debuff:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_darkness_taunt_debuff:GetStatusEffectName()
    return "particles/heroes/anime_hero_darkness/darkness_taunt_status_effect.vpcf"
end
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
darkness_shield = class({})

function darkness_shield:IsStealable()             return true end
function darkness_shield:IsHiddenWhenStolen()      return false end
function darkness_shield:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function darkness_shield:GetAbilityTextureName()
    return HasAnimeArcana(self:GetCaster()) 
           and "anime_hero_darkness/darkness_shield_arcana" 
           or self.BaseClass.GetAbilityTextureName(self)
end
function darkness_shield:OnSpellStart()
    local hCaster    = self:GetCaster()
    local iCasterLoc = hCaster:GetAbsOrigin()
    local fRadius = self:GetAOERadius()
    local fDuration  = self:GetSpecialValueFor("duration")

    if hCaster:HasModifier("modifier_item_aghanims_shard") then 
        fRadius = 30000
    else
        fRadius = self:GetAOERadius()
    end
    local hEnemies = FindUnitsInRadius(  
                                        hCaster:GetTeamNumber(),
                                        iCasterLoc,
                                        nil,
                                        fRadius,
                                        self:GetAbilityTargetTeam(),
                                        self:GetAbilityTargetType(),
                                        self:GetAbilityTargetFlags(),
                                        FIND_ANY_ORDER,
                                        false)

    for _, hEnemy in pairs(hEnemies) do
        if hEnemy ~= nil then
            hEnemy:AddNewModifier(hCaster, self, "modifier_darkness_shield_buff", {duration = fDuration})
        end
    end

    local sShieldPFX = "particles/heroes/anime_hero_darkness/darkness_shield_cast.vpcf"
    local iShieldPFX =  ParticleManager:CreateParticle( sShieldPFX, PATTACH_ABSORIGIN_FOLLOW, hCaster )
                        ParticleManager:SetParticleControlEnt(
                                                                iShieldPFX,
                                                                0,
                                                                hCaster,
                                                                PATTACH_POINT_FOLLOW,
                                                                "attach_attack1",
                                                                Vector(0,0,0), -- unknown
                                                                true -- unknown, true
                                                            )
                        ParticleManager:SetParticleControlEnt(
                                                                iShieldPFX,
                                                                1,
                                                                hCaster,
                                                                PATTACH_POINT_FOLLOW,
                                                                "attach_attack2",
                                                                Vector(0,0,0), -- unknown
                                                                true -- unknown, true
                                                            )
                        ParticleManager:SetParticleControl( iShieldPFX, 2, Vector( fRadius, 0, 0 ) )
                        ParticleManager:ReleaseParticleIndex( iShieldPFX )

    local sShieldSFX = HasAnimeArcana(hCaster)
                       and "Darkness.Shield.Cast.1.Arcana"
                       or "Darkness.Shield.Cast.1"

    EmitSoundOn(sShieldSFX, hCaster)
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_darkness_shield_buff", "GoU/heroes/anime_hero_darkness", LUA_MODIFIER_MOTION_NONE)

modifier_darkness_shield_buff = class({})

function modifier_darkness_shield_buff:IsHidden()               return false end
function modifier_darkness_shield_buff:IsDebuff()               return false end
function modifier_darkness_shield_buff:IsPurgable()             return true end
function modifier_darkness_shield_buff:IsPurgeException()       return true end
function modifier_darkness_shield_buff:RemoveOnDeath()          return true end
function modifier_darkness_shield_buff:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
                        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
                    }
    return func
end
function modifier_darkness_shield_buff:GetModifierPhysical_ConstantBlock(keys)
    if IsServer() then 
        local sShieldPFX = HasAnimeArcana(self.caster)
                           and "particles/heroes/anime_hero_darkness/darkness_shield_impact_arcana.vpcf"
                           or "particles/heroes/anime_hero_darkness/darkness_shield_impact.vpcf"

        local iShieldPFX =  ParticleManager:CreateParticle( sShieldPFX, PATTACH_ABSORIGIN_FOLLOW, self.parent )
                            ParticleManager:SetParticleControlEnt(
                                                                    iShieldPFX,
                                                                    0,
                                                                    self.parent,
                                                                    PATTACH_OVERHEAD_FOLLOW,
                                                                    "attach_hitloc",
                                                                    Vector(0,0,0), -- unknown
                                                                    true -- unknown, true
                                                                )
                            ParticleManager:SetParticleControlEnt(
                                                                    iShieldPFX,
                                                                    1,
                                                                    self.parent,
                                                                    PATTACH_ABSORIGIN_FOLLOW,
                                                                    "attach_hitloc",
                                                                    Vector(0,0,0), -- unknown
                                                                    true -- unknown, true
                                                                )
                            ParticleManager:ReleaseParticleIndex( iShieldPFX )

        return self.fDamageBlock
    end
end
function modifier_darkness_shield_buff:GetModifierMagicalResistanceBonus(keys)
    return self.fBonusMagicResist
end
function modifier_darkness_shield_buff:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    self.fDamageBlock      = self.ability:GetSpecialValueFor("damage_block")
    self.fBonusMagicResist = self.ability:GetSpecialValueFor("bonus_magic_resist")

    if IsClient() and not self.iShieldPFX then
        local sShieldPFX = HasAnimeArcana(self.caster)
                           and "particles/heroes/anime_hero_darkness/darkness_shield_arcana.vpcf"
                           or "particles/heroes/anime_hero_darkness/darkness_shield.vpcf"

        self.iShieldPFX =   ParticleManager:CreateParticle( sShieldPFX, PATTACH_ABSORIGIN_FOLLOW, self.parent )
                            ParticleManager:SetParticleControlEnt(
                                                                    self.iShieldPFX,
                                                                    0,
                                                                    self.parent,
                                                                    PATTACH_OVERHEAD_FOLLOW,
                                                                    "attach_hitloc",
                                                                    Vector(0,0,0), -- unknown
                                                                    true -- unknown, true
                                                                )
                            ParticleManager:SetParticleControlEnt(
                                                                    self.iShieldPFX,
                                                                    1,
                                                                    self.parent,
                                                                    PATTACH_ABSORIGIN_FOLLOW,
                                                                    "attach_hitloc",
                                                                    Vector(0,0,0), -- unknown
                                                                    true -- unknown, true
                                                                )

        self:AddParticle(self.iShieldPFX, false, false, -1, false, false)
    end
end
function modifier_darkness_shield_buff:OnRefresh(hTable)
    self:OnCreated(hTable)
end
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
darkness_impulsive = class({})

function darkness_impulsive:IsStealable()               return true end
function darkness_impulsive:IsHiddenWhenStolen()        return false end
function darkness_impulsive:GetIntrinsicModifierName()
    return "modifier_darkness_impulsive"
end
function darkness_impulsive:GetAbilityTextureName()
    return HasAnimeArcana(self:GetCaster())
           and "anime_hero_darkness/darkness_impulsive_arcana" 
           or self.BaseClass.GetAbilityTextureName(self)
end
function darkness_impulsive:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
-----------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_darkness_impulsive", "GoU/heroes/anime_hero_darkness", LUA_MODIFIER_MOTION_NONE)

modifier_darkness_impulsive = class({})

function modifier_darkness_impulsive:IsHidden()               return true end
function modifier_darkness_impulsive:IsDebuff()               return false end
function modifier_darkness_impulsive:IsPurgable()             return false end
function modifier_darkness_impulsive:IsPurgeException()       return false end
function modifier_darkness_impulsive:RemoveOnDeath()          return false end
function modifier_darkness_impulsive:DeclareFunctions()
    local func =    {
                        MODIFIER_EVENT_ON_ATTACK_LANDED
                    }
    return func
end
function modifier_darkness_impulsive:OnAttackLanded(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        local hTarget   = keys.target
        if not self.parent then return end
            self.fChance = 25
        if self.parent ~= nil
            and not self.parent:PassivesDisabled()
            and ( self.parent == hTarget or ( self.parent == hAttacker) )
            and self.ability:IsFullyCastable()
            and RollPseudoRandom(self.fChance, self) then
            local hEnemies = FindUnitsInRadius( 
                                                self.CASTER_TEAM,
                                                self.parent:GetAbsOrigin(),
                                                nil,
                                                self.fRadius,
                                                self.ABILITY_TARGET_TEAM,
                                                self.ABILITY_TARGET_TYPE,
                                                self.ABILITY_TARGET_FLAGS,
                                                FIND_ANY_ORDER,
                                                false)

            for _, hEnemy in pairs(hEnemies) do
                if hEnemy ~= nil then
                        ApplyDamage({victim = hEnemy,
                            damage = self.fDamage,
                            damage_type = self.ability:GetAbilityDamageType(),
                            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
                            attacker = self.caster,
                            ability = self:GetAbility()
                        })
                end
            end

            self.ability:UseResources(true, false, true)

            self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, 0.75)

            local sImpulsivePFX = HasAnimeArcana(self.parent)
                                  and "particles/heroes/anime_hero_darkness/darkness_impulsive_impact_arcana.vpcf"
                                  or "particles/heroes/anime_hero_darkness/darkness_impulsive_impact.vpcf"

            local iImpulsivePFX =   ParticleManager:CreateParticle( sImpulsivePFX, PATTACH_ABSORIGIN_FOLLOW, self.parent )
                                    ParticleManager:ReleaseParticleIndex( iImpulsivePFX )

            local sImpulsiveSFX = HasAnimeArcana(self.parent)
                                  and RandomInt(1, 6)..".Arcana"
                                  or RandomInt(1, 3)

            if self.parent:GetHealthPercent() <= 20 then
                if RollPseudoRandom(50, self.parent) then
                    sImpulsiveSFX = RandomInt(1, 2)..".Low.Hp.Arcana"
                end
            end
            
            EmitSoundOn( "Darkness.Impulsive.Cast."..sImpulsiveSFX, self.parent )
        end
    end
end
function modifier_darkness_impulsive:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    self.fRadius = self.ability:GetAOERadius()

    self.fDamage          = self.ability:GetSpecialValueFor("damage")
    self.fChance          = self.ability:GetSpecialValueFor("chance")
    if IsServer() then
        self.CASTER_TEAM          = self.caster:GetTeamNumber()
        self.ABILITY_TARGET_TEAM  = self.ability:GetAbilityTargetTeam() 
        self.ABILITY_TARGET_TYPE  = self.ability:GetAbilityTargetType()
        self.ABILITY_TARGET_FLAGS = self.ability:GetAbilityTargetFlags()
    end
end
function modifier_darkness_impulsive:OnRefresh(hTable)
    self:OnCreated(hTable)
end
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
darkness_blush = class({})

function darkness_blush:IsStealable()               return true end
function darkness_blush:IsHiddenWhenStolen()        return false end
function darkness_blush:IsLearned()                 return true end
function darkness_blush:GetIntrinsicModifierName()
    return "modifier_darkness_blush"
end
function darkness_blush:GetAbilityTextureName()
    return HasAnimeArcana(self:GetCaster())
           and "anime_hero_darkness/darkness_blush_arcana" 
           or self.BaseClass.GetAbilityTextureName(self)
end
function darkness_blush:GetAOERadius() return self:GetSpecialValueFor("radius") end

LinkLuaModifier("modifier_darkness_blush", "GoU/heroes/anime_hero_darkness", LUA_MODIFIER_MOTION_NONE)

modifier_darkness_blush = class({})

function modifier_darkness_blush:IsHidden()                     return false end
function modifier_darkness_blush:IsDebuff()                     return false end
function modifier_darkness_blush:IsPurgable()                   return false end
function modifier_darkness_blush:IsPurgeException()             return false end
function modifier_darkness_blush:RemoveOnDeath()                return false end
function modifier_darkness_blush:IsAura()                       return true end
function modifier_darkness_blush:IsAuraActiveOnDeath()          return false end
function modifier_darkness_blush:DeclareFunctions()
    local func =    {  
                        MODIFIER_PROPERTY_MISS_PERCENTAGE
                    }
    return func
end
function modifier_darkness_blush:GetModifierMiss_Percentage(keys)
    return self:GetStackCount()
end
function modifier_darkness_blush:GetAuraEntityReject(hEntity)
    return self.parent:PassivesDisabled() or hEntity == self.parent
end
function modifier_darkness_blush:GetAuraRadius()
    return self.fRadius
end
function modifier_darkness_blush:GetAuraSearchTeam()
    return self.ABILITY_TARGET_TEAM
end
function modifier_darkness_blush:GetAuraSearchType()
    return self.ABILITY_TARGET_TYPE
end
function modifier_darkness_blush:GetAuraSearchFlags()
    return self.ABILITY_TARGET_FLAGS
end
function modifier_darkness_blush:GetModifierAura()
    return "modifier_darkness_blush_debuff"
end
function modifier_darkness_blush:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    self.fRadius          = self.ability:GetAOERadius()
    self.iStartChanceMiss = self.ability:GetSpecialValueFor("start_chance_to_miss")

    if IsServer() then
        self.ABILITY_TARGET_TEAM  = self.ability:GetAbilityTargetTeam() 
        self.ABILITY_TARGET_TYPE  = self.ability:GetAbilityTargetType()
        self.ABILITY_TARGET_FLAGS = self.ability:GetAbilityTargetFlags()

        self:SetStackCount(self.iStartChanceMiss)
    end
end
function modifier_darkness_blush:OnRefresh(hTable)
    self:OnCreated(hTable)
end
-----------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_darkness_blush_debuff", "GoU/heroes/anime_hero_darkness", LUA_MODIFIER_MOTION_NONE)

modifier_darkness_blush_debuff = class({})

function modifier_darkness_blush_debuff:IsHidden()            return true end
function modifier_darkness_blush_debuff:IsDebuff()            return true end
function modifier_darkness_blush_debuff:IsPurgable()          return true end
function modifier_darkness_blush_debuff:IsPurgeException()    return true end
function modifier_darkness_blush_debuff:RemoveOnDeath()       return true end
function modifier_darkness_blush_debuff:GetAttributes()       return MODIFIER_ATTRIBUTE_AURA_PRIORITY + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_darkness_blush_debuff:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    self.iChanceReduce = self.ability:GetSpecialValueFor("chance_reduce")

    if IsServer() then
        local iCurrentStacks = self.caster:GetModifierStackCount("modifier_darkness_blush", self.caster)
        local base_chan = iCurrentStacks + self.iChanceReduce
        if base_chan <=0 then base_chan = 1 end
        if base_chan >=100 then base_chan = 99 end
        self.caster:SetModifierStackCount("modifier_darkness_blush", self.caster, base_chan)
    end
end
function modifier_darkness_blush_debuff:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_darkness_blush_debuff:OnRemoved()
    if IsServer() and self.caster ~= nil then
        local iCurrentStacks = self.caster:GetModifierStackCount("modifier_darkness_blush", self.caster)
        local base_chan = iCurrentStacks - self.iChanceReduce
        if base_chan <=0 then base_chan = 1 end
        if base_chan >=100 then base_chan = 99 end
        self.caster:SetModifierStackCount("modifier_darkness_blush", self.caster, base_chan)
    end
end
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
darkness_endurance = class({})

function darkness_endurance:IsStealable()               return true end
function darkness_endurance:IsHiddenWhenStolen()        return false end
function darkness_endurance:GetIntrinsicModifierName()
    return "modifier_darkness_endurance"
end
function darkness_endurance:GetAbilityTextureName()
    return HasAnimeArcana(self:GetCaster()) 
           and "anime_hero_darkness/darkness_endurance_arcana" 
           or self.BaseClass.GetAbilityTextureName(self)
end
-----------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_darkness_endurance", "GoU/heroes/anime_hero_darkness", LUA_MODIFIER_MOTION_NONE)

modifier_darkness_endurance = class({})

function modifier_darkness_endurance:IsHidden()                 return true end
function modifier_darkness_endurance:IsDebuff()                 return false end
function modifier_darkness_endurance:IsPurgable()               return false end
function modifier_darkness_endurance:IsPurgeException()         return false end
function modifier_darkness_endurance:RemoveOnDeath()            return false end
function modifier_darkness_endurance:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
                    }
    return func
end
function modifier_darkness_endurance:GetModifierBonusStats_Strength(keys)
    return self.fBonusStrPct
end
function modifier_darkness_endurance:GetModifierStatusResistanceStacking(keys)
    return self.fBonusStatusResist
end
function modifier_darkness_endurance:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    self.fBonusStrPct = 0
    self.fBonusStrPct = self.parent:GetStrength() * self.ability:GetSpecialValueFor("bonus_str_pct") * 0.01

    self.fBonusStatusResist = self.ability:GetSpecialValueFor("bonus_status_resist")

    if IsServer() and self.parent then
        self.SAVE_hTable = hTable

        self.parent:CalculateStatBonus(true)

        self:StartIntervalThink(0.5)
    end
end
function modifier_darkness_endurance:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_darkness_endurance:OnIntervalThink()
    if IsServer() then
        self:OnCreated(self.SAVE_hTable)
    end
end
function UseGoldBag(keys)
    local Caster = keys.caster
    local ability = keys.ability

    if not Caster:IsRealHero() then
        return
    end

    local randomCount = RandomInt(1, 10)

    local gold = RandomInt(1, 1000)
    Caster:ModifyGold(gold, true, 0) 

    local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas_b.vpcf", PATTACH_OVERHEAD_FOLLOW, Caster)   
    ParticleManager:SetParticleControlEnt(midas_particle, 1, Caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Caster:GetAbsOrigin(), false)
    ParticleManager:ReleaseParticleIndex(midas_particle)
    Caster:EmitSound("DOTA_Item.Hand_Of_Midas")
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, Caster, gold, nil)

    Caster:RemoveItem(ability)
end
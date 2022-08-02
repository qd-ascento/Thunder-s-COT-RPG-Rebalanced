function DebugPrint(...)
	if USE_DEBUG then
		print(...)
	end
end

function FormatLongNumber(n)
  if n >= 10^9 then
        return string.format("%.2fb", n / 10^9)
    elseif n >= 10^6 then
        return string.format("%.2fm", n / 10^6)

    elseif n >= 10^3 then
        return string.format("%.2fk", n / 10^3)
    else
        return tostring(n)
    end
end

function callIfCallable(f)
    return function(...)
        error, result = pcall(f, ...)
        if error then -- f exists and is callable
            print('ok')
            return result
        end
        -- nothing to do, as though not called, or print('error', result)
    end
end

function CDOTA_BaseNPC:FindItemInAnyInventory(name)
  local pass = nil

  for i=0,14 do
      local item = self:GetItemInSlot(i)
      if item ~= nil then
          if item:GetAbilityName() == name then
              pass = item
              break
          end
      end
  end

  return pass
end


function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function ToRadians(degrees)
  return degrees * math.pi / 180
end

function RotateVector2D(vector, theta)
    local xp = vector.x*math.cos(theta)-vector.y*math.sin(theta)
    local yp = vector.x*math.sin(theta)+vector.y*math.cos(theta)
    return Vector(xp,yp,vector.z):Normalized()
end

function CDOTABaseAbility:FireLinearProjectile(FX, velocity, distance, width, data, bDelete, bVision, vision)
  local internalData = data or {}
  local delete = false
  if bDelete then delete = bDelete end
  local provideVision = true
  if bVision then provideVision = bVision end
  if internalData.source and not internalData.origin then
    internalData.origin = internalData.source:GetAbsOrigin()
  end
  local info = {
    EffectName = FX,
    Ability = self,
    vSpawnOrigin = internalData.origin or self:GetCaster():GetAbsOrigin(), 
    fStartRadius = width,
    fEndRadius = internalData.width_end or width,
    vVelocity = velocity,
    fDistance = distance or 1000,
    Source = internalData.source or self:GetCaster(),
    iUnitTargetTeam = internalData.team or DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetType = internalData.type or DOTA_UNIT_TARGET_ALL,
    iUnitTargetFlags = internalData.type or DOTA_UNIT_TARGET_FLAG_NONE,
    iSourceAttachment = internalData.attach or DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
    bDeleteOnHit = delete,
    fExpireTime = GameRules:GetGameTime() + 10.0,
    bProvidesVision = provideVision,
    iVisionRadius = vision or 100,
    iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    ExtraData = internalData.extraData
  }
  local projectile = ProjectileManager:CreateLinearProjectile( info )
  return projectile
end

function CDOTABaseAbility:FireTrackingProjectile(FX, target, speed, data, iAttach, bDodge, bVision, vision)
  local internalData = data or {}
  local dodgable = true
  if bDodge ~= nil then dodgable = bDodge end
  local provideVision = false
  if bVision ~= nil then provideVision = bVision end
  origin = self:GetCaster():GetAbsOrigin()
  if internalData.origin then
    origin = internalData.origin
  elseif internalData.source then
    origin = internalData.source:GetAbsOrigin()
  end
  local projectile = {
    Target = target,
    Source = internalData.source or self:GetCaster(),
    Ability = self, 
    EffectName = FX,
      iMoveSpeed = speed,
    vSourceLoc= origin or self:GetCaster():GetAbsOrigin(),
    bDrawsOnMinimap = false,
        bDodgeable = dodgable,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = internalData.duration,
    bProvidesVision = provideVision,
    iVisionRadius = vision or 100,
    iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    iSourceAttachment = iAttach or 3,
    ExtraData = internalData.extraData
  }
  return ProjectileManager:CreateTrackingProjectile(projectile)
end

function CDOTA_BaseNPC:HasTalent(talentName)
  if self and not self:IsNull() and self:HasAbility(talentName) then
    if self:FindAbilityByName(talentName):GetLevel() > 0 then return true end
  end

  return false
end

function maxFreq(arr, n, fallback)
  table.sort(arr)
  -- we do this so it falls back to the default value
  table.insert(arr, fallback)
  n= n + 1
  --

  local max_count = 1
  local res = arr[1]

  local curr_count = 1

  for i = 1, n do 
    if arr[i] == arr[i - 1] then
        curr_count = curr_count + 1
    else
        if curr_count > max_count then
            max_count = curr_count
            res = arr[i - 1]
        end

        curr_count = 1
    end
  end

  if curr_count > max_count then
    max_count = curr_count
    res = arr[n - 1]
  end

  return res
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function DebugPrintTable(...)
  local spew = Convars:GetInt('barebones_spew') or -1
  if spew == -1 and BAREBONES_DEBUG_SPEW then
    spew = 1
  end

  if spew == 1 then
    PrintTable(...)
  end
end

function UnitIsNotMonkeyClone(hero)
    return (not hero:HasModifier("modifier_monkey_king_fur_army_soldier") and 
            not hero:HasModifier("modifier_monkey_king_fur_army_soldier_hidden") and
            not hero:HasModifier("modifier_monkey_king_fur_army_soldier_inactive") and
            not hero:HasModifier("modifier_monkey_king_fur_army_soldier_in_position") and
            hero:GetUnitName() ~= "npc_dota_monkey_clone_custom")
end

function IsCreepTCOTRPG(unit)
  if not unit or unit:IsNull() then return false end

  if string.find(unit:GetUnitName(), "npc_dota_wave") then return true end

  local unitNames = {
    "npc_dota_creature_1_crip",
    "npc_dota_creature_30_crip",
    "npc_dota_creature_40_crip",
    "npc_dota_creature_40_crip_2",
    "npc_dota_creature_130_crip2_death",
    "npc_dota_creature_130_crip1_death",
    "npc_dota_creature_70_crip",
    "npc_dota_creature_50_crip",
    "npc_dota_creature_100_crip",
    "npc_dota_creature_10_crip_2",
    "npc_dota_creature_10_crip_3",
    "npc_dota_creature_30_crip_2",
    "npc_dota_creature_140_crip_Robo",
    "npc_dota_creature_120_crip_snow",
    "npc_dota_creature_100_crip_2",
    "npc_dota_creature_10_crip_4",
    "npc_dota_creature_70_crip_2"
  }

  for _,theUnit in ipairs(unitNames) do
    if unit:GetUnitName() == theUnit then return true end
  end

  return false
end

function DisplayError(playerID, message)
  local player = PlayerResource:GetPlayer(playerID)
  if player then
    CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message=message})
  end
end

function IsBossTCOTRPG(unit)
  if not unit or unit:IsNull() then return false end

  local bossNames = {
    "npc_dota_creature_80_boss",
    "npc_dota_creature_70_boss",
    "npc_dota_creature_40_boss_2",
    "npc_dota_creature_30_boss",
    "npc_dota_creature_40_boss",
    "npc_dota_creature_50_boss",
    "npc_dota_creature_100_boss",
    "npc_dota_creature_100_boss_2",
    "npc_dota_creature_130_boss_death",
    "npc_dota_creature_150_boss_last",
    "npc_dota_creature_10_boss",
    "npc_dota_creature_20_boss",
    "npc_dota_creature_roshan_boss",
    "npc_dota_creature_100_boss_3",
    "npc_dota_creature_100_boss_4",
    "npc_dota_creature_100_boss_5",
    "npc_dota_creature_target_dummy",
  }

  for _,boss in ipairs(bossNames) do
    if unit:GetUnitName() == boss then return true end
  end

  return false
end

function CreateParticleWithTargetAndDuration(particleName, target, duration)
  local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

  Timers:CreateTimer(duration, function()
      ParticleManager:DestroyParticle(particle, true)
      ParticleManager:ReleaseParticleIndex(particle)
  end)

  return particle
end

function ClearItems(mustHaveOwner)
  local items_on_the_ground = Entities:FindAllByClassname("dota_item_drop")
  for _,item in pairs(items_on_the_ground) do
    local containedItem = item:GetContainedItem()
    if containedItem then
      local owner = containedItem:GetOwnerEntity()

      local creationTime = math.floor(item:GetCreationTime())
      local gameTime = math.floor(GameRules:GetGameTime())

      local name = containedItem:GetAbilityName()

      if string.find(name, "recipe") then
        break
      end

      if containedItem and (mustHaveOwner and owner == nil and ((gameTime - creationTime) > 90)) then
        UTIL_RemoveImmediate(item)
        UTIL_RemoveImmediate(containedItem)
      end
    end
  end
end

function GetRealConnectedHeroCount()
  local heroes = HeroList:GetAllHeroes()
  local amount = 0
  for _,hero in ipairs(heroes) do
    local connectionState = PlayerResource:GetConnectionState(hero:GetPlayerID())
    if connectionState == DOTA_CONNECTION_STATE_CONNECTED and UnitIsNotMonkeyClone(hero) and not hero:IsIllusion() and hero:IsRealHero() and not hero:IsClone() and not hero:IsTempestDouble() and  hero:GetUnitName() ~= "outpost_placeholder_unit" then
      amount = amount + 1
    end
  end

  return amount
end

function GetRealHeroCount()
  local heroes = HeroList:GetAllHeroes()
  local amount = 0
  for _,hero in ipairs(heroes) do
    if UnitIsNotMonkeyClone(hero) and not hero:IsIllusion() and hero:IsRealHero() and not hero:IsClone() and not hero:IsTempestDouble() and  hero:GetUnitName() ~= "outpost_placeholder_unit" then
      amount = amount + 1
    end
  end

  return amount
end


function IsInTrigger(entity, trigger)
  if not entity:IsAlive() then return false end

  local triggerOrigin = trigger:GetAbsOrigin()
  local bounds = trigger:GetBounds()

  local origin = entity
  if entity.GetAbsOrigin then
    origin = entity:GetAbsOrigin()
  end

  if origin.x < bounds.Mins.x + triggerOrigin.x then
    return false
  end
  if origin.y < bounds.Mins.y + triggerOrigin.y then
    return false
  end
  if origin.x > bounds.Maxs.x + triggerOrigin.x then
    return false
  end
  if origin.y > bounds.Maxs.y + triggerOrigin.y then
    return false
  end

  return true
end

function PrintTable(t, indent, done)
  --print ( string.format ('PrintTable type %s', type(keys)) )
  if type(t) ~= "table" then return end

  done = done or {}
  done[t] = true
  indent = indent or 0

  local l = {}
  for k, v in pairs(t) do
    table.insert(l, k)
  end

  table.sort(l)
  for k, v in ipairs(l) do
    -- Ignore FDesc
    if v ~= 'FDesc' then
      local value = t[v]

      if type(value) == "table" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..":")
        PrintTable (value, indent + 2, done)
      elseif type(value) == "userdata" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
      else
        if t.FDesc and t.FDesc[v] then
          print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
        else
          print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        end
      end
    end
  end
end

-- Requires an element and a table, returns true if element is in the table.
function TableContains(t, element)
    if t == nil then return false end
    for k,v in pairs(t) do
        if k == element then
            return true
        end
    end
    return false
end

-- Return length of the table even if the table is nil or empty
function TableLength(t)
    if t == nil or t == {} then
        return 0
    end
    local length = 0
    for k,v in pairs(t) do
        length = length + 1
    end
    return length
end

function GetRandomTableElement(t)
    -- iterate over whole table to get all keys
    local keyset = {}
    for k in pairs(t) do
        table.insert(keyset, k)
    end
    -- now you can reliably return a random key
    return t[keyset[RandomInt(1, #keyset)]]
end

-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'

function DebugAllCalls()
    if not GameRules.DebugCalls then
        print("Starting DebugCalls")
        GameRules.DebugCalls = true

        debug.sethook(function(...)
            local info = debug.getinfo(2)
            local src = tostring(info.short_src)
            local name = tostring(info.name)
            if name ~= "__index" then
                print("Call: ".. src .. " -- " .. name .. " -- " .. info.currentline)
            end
        end, "c")
    else
        print("Stopped DebugCalls")
        GameRules.DebugCalls = false
        debug.sethook(nil, "c")
    end
end

-- Author: Noya
-- This function hides all dota item cosmetics (hats/wearables) from the hero/unit and store them into a handle variable
-- Works only for wearables added with code
function HideWearables(unit)
  unit.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
  local model = unit:FirstMoveChild()
  while model ~= nil do
    if model:GetClassname() == "dota_item_wearable" then
      model:AddEffects(EF_NODRAW) -- Set model hidden
      table.insert(unit.hiddenWearables, model)
    end
    model = model:NextMovePeer()
  end
end

-- Author: Noya
-- This function un-hides (shows) wearables that were hidden with HideWearables() function.
function ShowWearables(unit)
	for i,v in pairs(unit.hiddenWearables) do
		v:RemoveEffects(EF_NODRAW)
	end
end

-- Author: Noya
-- This function changes (swaps) dota item cosmetic models (hats/wearables)
-- Works only for wearables added with code
function SwapWearable(unit, target_model, new_model)
    local wearable = unit:FirstMoveChild()
    while wearable ~= nil do
        if wearable:GetClassname() == "dota_item_wearable" then
            if wearable:GetModelName() == target_model then
                wearable:SetModel(new_model)
                return
            end
        end
        wearable = wearable:NextMovePeer()
    end
end

-- This function checks if a given unit is Roshan, returns boolean value;
function CDOTA_BaseNPC:IsRoshan()
	if self:IsAncient() and self:GetUnitName() == "npc_dota_roshan" then
		return true
	end
	
	return false
end

-- This function checks if this entity is a fountain or not; returns boolean value;
function CBaseEntity:IsFountain()
	if self:GetName() == "ent_dota_fountain_bad" or self:GetName() == "ent_dota_fountain_good" then
		return true
	end
	
	return false
end

-- Author: Noya
-- This function is showing custom Error Messages using notifications library
function SendErrorMessage(pID, string)
  if Notifications then
    Notifications:ClearBottom(pID)
    Notifications:Bottom(pID, {text=string, style={color='#E62020'}, duration=2})
  end
  EmitSoundOnClient("General.Cancel", PlayerResource:GetPlayer(pID))
end

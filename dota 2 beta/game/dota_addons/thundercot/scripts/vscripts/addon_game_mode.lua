-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

-- Creating a global gamemode class variable;
if barebones == nil then
	_G.barebones = class({})
else
	DebugPrint("[BAREBONES] barebones class name is already in use, change the name if this is the first time you launch the game!")
	DebugPrint("[BAREBONES] If this is not your first time, you probably used script_reload in console.")
end

require('util')
require('libraries/timers')                      -- Core lua library
require('libraries/player_resource')             -- Core lua library
require('gamemode')  
require("libraries/selection")                            -- Core barebones file
require("libraries/spell_caster")
require("libraries/projectiles") 
require("libraries/player")  
require('libraries/animations')
require('libraries/cfinder')

function Precache(context)
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

	DebugPrint("[BAREBONES] Performing pre-load precache")

	-- Particles can be precached individually or by folder
	-- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
	PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", context)
	PrecacheResource("particle", "particles/items2_fx/refresher.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/frostivus/frostivus_fireworks.vpcf", context)

	PrecacheResource("particle", "particles/econ/events/diretide_2020/emblem/fall20_emblem_v3_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/fall_2021/fall_2021_emblem_game_effect.vpcf", context)

	PrecacheResource("particle", "particles/econ/items/alchemist/alchemist_midas_knuckles/alch_hand_of_midas.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_clean_low.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_terrorblade/terrorblade_mirror_image.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_terrorblade_reflection.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_medusa_stone_gaze.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", context)
	PrecacheResource("particle", "particles/generic_gameplay/generic_manaburn.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context)
	PrecacheResource("particle", "particles/generic_gameplay/generic_disarm.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_techies/techies_blast_off.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_beserkers_call_owner.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_drow/drow_ice_trail.vpcf", context)

	
	PrecacheResource("model", "models/items/hex/sheep_hex/sheep_hex.vmdl", context)
	PrecacheResource("model", "models/units/zaken/zaken.vmdl", context)
	PrecacheResource("model", "models/units/saitama/zasaitamaken.vmdl", context)
	PrecacheResource("model", "models/hero_shinobu/shinobu_01.vmdl", context)
	PrecacheResource("model", "models/units/stegius/stegius.vmdl", context)
	PrecacheResource("particle_folder", "particles/test_particle", context)

	PrecacheResource("particle_folder", "particles/dazzle/dazzle_shadow_step.vpcf", context)
  PrecacheResource("particle_folder", "particles/dazzle/wd_ti10_immortal_voodoo_center.vpcf", context)
  PrecacheResource("particle_folder", "particles/dazzle/wd_ti10_immortal_voodoo_ember.vpcf", context)
  PrecacheResource("particle_folder", "particles/dazzle/wd_ti10_immortal_voodoo_flame.vpcf", context)
  PrecacheResource("particle_folder", "particles/dazzle/wd_ti10_immortal_voodoo_glow.vpcf", context)
  PrecacheResource("particle_folder", "particles/dazzle/wd_ti10_immortal_voodoo_grass.vpcf", context)
  PrecacheResource("particle_folder", "particles/dazzle/wd_ti10_immortal_voodoo_ground_cover.vpcf", context)
  PrecacheResource("particle_folder", "particles/dazzle/wd_ti10_immortal_voodoo_projection.vpcf", context)
  PrecacheResource("particle_folder", "particles/dazzle/wd_ti10_immortal_voodoo_ring.vpcf", context)
  PrecacheResource("particle_folder", "particles/dazzle/wd_ti10_immortal_voodoo_spore.vpcf", context)

	-- Models can also be precached by folder or individually
	-- PrecacheModel should generally used over PrecacheResource for individual models

	--PrecacheResource("model_folder", "particles/heroes/antimage", context)
	--PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
	--PrecacheModel("models/heroes/viper/viper.vmdl", context)
	--PrecacheModel("models/props_gameplay/treasure_chest001.vmdl", context)
	--PrecacheModel("models/props_debris/merchant_debris_chest001.vmdl", context)
	--PrecacheModel("models/props_debris/merchant_debris_chest002.vmdl", context)

	-- Sounds can precached here like anything else
	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_pangolier.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_mars.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_huskar.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_sandking.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_life_stealer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_arena.vsndevts", context)


	PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_juggernaut.vsndevts", context)
	
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts", context)

	-- Entire items can be precached by name
	-- Abilities can also be precached in this way despite the name
	PrecacheItemByNameSync("example_ability", context)
	PrecacheItemByNameSync("item_example_item", context)

	-- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
	-- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
	PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	PrecacheUnitByNameSync("npc_dota_hero_enigma", context)

	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_spectre.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_items.vsndevts", context)
end

require("duel")


LinkLuaModifier("modifier_int_scaling", "modifiers/modifier_int_scaling.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_auto_pickup", "modifiers/modifier_auto_pickup.lua", LUA_MODIFIER_MOTION_NONE)

-- Create the game mode when we activate
function Activate()
	barebones:InitGameMode()

	_G.tPlayers 				= {}
	_G.tHeroesRadiant 			= {}
	_G.tHeroesDire 				= {}
	_G.SummonedZeus = false
	_G.SummonedZeusDeaths = 0
	_G.receivedGold 			= {}
	_G.autoPickup 				= {}
	_G.lostItems				= {}
	_G.bWavesEnabled = false
	_G.stageSkafian = 1
	_G.morplingPartChance = 0.13
	_G.PlayerAddedAbilityCount = {}
	_G.PlayerBookRandomAbilities = {}
	_G.PlayerStoredAbilities = {}
	_G.PlayerDamageTimer = {}
	_G.PlayerDamageTest = {}
	_G.DifficultyEasyBuffs = {}
	_G.DifficultyNormalPlayerBuffs = {}
	_G.DifficultyNormalEnemyBuffs = {}
	_G.DifficultyHardPlayerBoons = {}
	_G.DifficultyHardEnemyBuffs = {}
	_G.DifficultyUnfairPlayerBoons = {}
	_G.DifficultyUnfairEnemyBuffs = {}
	_G.DifficultyImpossiblePlayerBoons = {}
	_G.DifficultyImpossibleEnemyBuffs = {}
	_G.DifficultyHellPlayerBoons = {}
	_G.DifficultyHellEnemyBuffs = {}
	_G.DifficultyHardcorePlayerBoons = {}
	_G.DifficultyHardcoreEnemyBuffs = {}
	_G.MovementFreezeCounter = {} -- Used for the movement freeze difficulty modifier. Contains player ID's and counts.
	_G.PlayerNeutralDropCooldowns = {}

	if GetMapName() == "tcotrpg_1v1" then
		InitDuel()
	end

	-- Clear drops --
	Timers:CreateTimer(10.0, function()
		ClearItems(true) -- Removes containers, etc. dropped on the ground by creeps
		return 10.0
	end)

	--PrintTable(LoadKeyValues("scripts/npc/npc_abilities.txt"))
end
-- In this file you can set up all the properties and settings for your game mode.
USE_DEBUG = false                       -- Should we print statements on almost every function/event call? For debugging.
KILL_VOTE_RESULT = {}
KILL_VOTE_DEFAULT = "NORMAL"
EFFECT_VOTE_RESULT = {}
EFFECT_VOTE_DEFAULT = "ENABLE"

WAVE_VOTE_RESULT = {}
WAVE_VOTE_DEFAULT = "ENABLE"

ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = true             -- Should the shops contain all items?
ALLOW_SAME_HERO_SELECTION = false       -- Should we let people select the same hero as each other
LOCK_TEAMS = false                      -- Should we Lock (true) or unlock (false) team assignemnt. If team assignment is locked players cannot change teams.

CUSTOM_GAME_SETUP_TIME = 25.0           -- How long should custom game setup last - the screen where players pick a team?
HERO_SELECTION_TIME = 30.0              -- How long should we let people select their hero? Should be at least 5 seconds.
HERO_SELECTION_PENALTY_TIME = 30.0      -- How long should the penalty time for not picking a hero last? During this time player loses gold.
ENABLE_BANNING_PHASE = false            -- Should we enable banning phase? Set to true if "EnablePickRules" is "1" in 'addoninfo.txt'
BANNING_PHASE_TIME = 20.0               -- How long should the banning phase last? This will work only if "EnablePickRules" is "1" in 'addoninfo.txt'
STRATEGY_TIME = 0.0                    -- How long should strategy time last? Bug: You can buy items during strategy time and it will not be spent!
SHOWCASE_TIME = 0.0                    -- How long should show case time be?
PRE_GAME_TIME = 0.0                    -- How long after showcase time should the horn blow and the game start?
POST_GAME_TIME = 15.0                   -- How long should we let people stay around before closing the server automatically?
TREE_REGROW_TIME = 120.0                -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 3                     -- How much gold should players get per tick? DOESN'T WORK
GOLD_TICK_TIME = 1.0                    -- How long should we wait in seconds between gold ticks? DOESN'T WORK

NORMAL_START_GOLD = 850                 -- Starting Gold

RECOMMENDED_BUILDS_DISABLED = false     -- Should we disable the recommended item builds for heroes? Turns the panel for showing recommended items at the shop off/on.
CAMERA_DISTANCE_OVERRIDE = 1134.0       -- How far out should we allow the camera to go? 1134 is the default in Dota.

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

BUYBACK_ENABLED = false                  -- Should we allow players to buyback when they die?
CUSTOM_BUYBACK_COST_ENABLED = false     -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = false -- Should we use a custom buyback time?
CUSTOM_BUYBACK_COOLDOWN_TIME = 480.0    -- Custom buyback cooldown time (needed if CUSTOM_BUYBACK_COOLDOWN_ENABLED is true).
BUYBACK_FIXED_GOLD_COST = 500           -- Fixed custom buyback gold cost (needed if CUSTOM_BUYBACK_COST_ENABLED is true).

CUSTOM_SCAN_COOLDOWN = 210              -- Custom cooldown of Scan in seconds. Doesn't affect Scan's starting cooldown!
CUSTOM_GLYPH_COOLDOWN = 300             -- Custom cooldown of Glyph in seconds. Doesn't affect Glyph's starting cooldown!

DISABLE_FOG_OF_WAR_ENTIRELY = false     -- Should we disable fog of war entirely for both teams?
USE_UNSEEN_FOG_OF_WAR = false           -- Should we make unseen and fogged areas of the map completely black until uncovered by each team? 
-- NOTE: DISABLE_FOG_OF_WAR_ENTIRELY must be false for USE_UNSEEN_FOG_OF_WAR to work
USE_STANDARD_DOTA_BOT_THINKING = false  -- Should we have bots act like they would in Dota? (This requires 3 lanes, vanilla items, vanilla heroes etc)

USE_CUSTOM_HERO_GOLD_BOUNTY = false     -- Should the gold for hero kills be modified (true) or same as in default Dota (false)?
HERO_KILL_GOLD_BASE = 110               -- Hero gold bounty base value
HERO_KILL_GOLD_PER_LEVEL = 10           -- Hero gold bounty increase per level
HERO_KILL_GOLD_PER_STREAK = 60          -- Hero gold bounty per his kill-streak (Killing Spree: +HERO_KILL_GOLD_PER_STREAK gold; Ultrakill: +2 x HERO_KILL_GOLD_PER_STREAK gold ...)
DISABLE_ALL_GOLD_FROM_HERO_KILLS = false    -- Should we remove gold gain from hero kills? USE_CUSTOM_HERO_GOLD_BOUNTY needs to be true.
-- NOTE: DISABLE_ALL_GOLD_FROM_HERO_KILLS requires GoldFilter.
USE_CUSTOM_HERO_LEVELS = true          -- Should the heroes give a custom amount of XP when killed? Can malfunction for levels above 30!

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false -- Should we enable backdoor protection for our buildings?
--REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies? DOESN'T WORK
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players acquire gold?

END_GAME_ON_KILLS = true               -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 20        -- How many kills for a team should signify an end of game?

USE_CUSTOM_XP_VALUES = true            -- Should we use custom XP values to level up heroes, or the default Dota numbers?
MAX_LEVEL = 999                          -- What level should we let heroes get to? (USE_CUSTOM_XP_VALUES must be true).
-- NOTE: MAX_LEVEL and XP_PER_LEVEL_TABLE will not work if USE_CUSTOM_XP_VALUES is false or nil.

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
XP_PER_LEVEL_TABLE[1] = 0
for i=2,MAX_LEVEL do
  XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + (i ^ 1.25) * 40
end

ENABLE_FIRST_BLOOD = true               -- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false               -- Should we hide the kill banners that show when a player is killed?
LOSE_GOLD_ON_DEATH = true               -- Should we have players lose the normal amount of dota gold on death?
SHOW_ONLY_PLAYER_INVENTORY = false      -- Should we allow players to only see their own inventory even when selecting other units?
DISABLE_STASH_PURCHASING = false        -- Should we prevent players from being able to buy items into their stash when not at a shop?
DISABLE_ANNOUNCER = false               -- Should we disable the announcer from working in the game?
FORCE_PICKED_HERO = nil                 -- What hero should we force all players to spawn as? (e.g. "npc_dota_hero_axe").  Use nil to allow players to pick their own hero.
-- This will not work if "EnablePickRules" is "1" in 'addoninfo.txt'!

ADD_ITEM_TO_HERO_ON_SPAWN = false       -- Add an example item to the picked hero when he spawns?

-- NOTE: use FIXED_RESPAWN_TIME if you want the same respawn time on every level.
MAX_RESPAWN_TIME = 5					-- Default Dota doesn't have a limit (it can go above 125). Fast game modes should have 20 seconds.
USE_CUSTOM_RESPAWN_TIMES = true		-- Should we use custom respawn times (true) or dota default (false)?

-- Fill this table with respawn times on each level if USE_CUSTOM_RESPAWN_TIMES is true.
CUSTOM_RESPAWN_TIME = {}

for i = 1, MAX_LEVEL do
    CUSTOM_RESPAWN_TIME[i] = 5
end

FOUNTAIN_CONSTANT_MANA_REGEN = 50       -- What should we use for the constant fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_MANA_REGEN = 20     -- What should we use for the percentage fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = 500  -- What should we use for the percentage fountain health regen?  Use -1 to keep the default dota behavior.
MAXIMUM_ATTACK_SPEED = 1750             -- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 10               -- What should we use for the minimum attack speed?

DISABLE_DAY_NIGHT_CYCLE = false         -- Should we disable the day night cycle from naturally occurring? (Manual adjustment still possible)
DISABLE_KILLING_SPREE_ANNOUNCER = false -- Should we disable the killing spree announcer?
DISABLE_STICKY_ITEM = false             -- Should we disable the sticky item button in the quick buy area?
ENABLE_PAUSING = true                   -- Should we allow players to pause the game?
DEFAULT_DOTA_COURIER = true             -- Enable courier for each player with default dota properties

FORCE_MINIMAP_ON_THE_LEFT = false       -- Should we disable hud flip aka force the default dota hud positions? 
-- Note: Some players have minimap on the right and gold/shop on the left.

USE_DEFAULT_RUNE_SYSTEM = false         -- Should we use the default dota rune spawn timings and the same runes as dota have?
BOUNTY_RUNE_SPAWN_INTERVAL = 60        -- How long in seconds should we wait between bounty rune spawns? BUGGED! WORKS FOR POWERUPS TOO!
POWER_RUNE_SPAWN_INTERVAL = 9999        -- How long in seconds should we wait between power-up runes spawns? BUGGED! WORKS FOR BOUNTIES TOO!

ENABLED_RUNES = {}                      -- Which power-up runes should be enabled to spawn in our game mode?
ENABLED_RUNES[DOTA_RUNE_DOUBLEDAMAGE] = true
ENABLED_RUNES[DOTA_RUNE_HASTE] = true
ENABLED_RUNES[DOTA_RUNE_ILLUSION] = true
ENABLED_RUNES[DOTA_RUNE_INVISIBILITY] = true
ENABLED_RUNES[DOTA_RUNE_REGENERATION] = true
ENABLED_RUNES[DOTA_RUNE_ARCANE] = true  -- BUGGED! NEVER SPAWNS!

MAX_NUMBER_OF_TEAMS = 1                         -- How many potential teams can be in this game mode?
USE_CUSTOM_TEAM_COLORS = false                  -- Should we use custom team colors?
USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = false      -- Should we use custom team colors to color the players/minimap?

TEAM_COLORS = {}                        -- If USE_CUSTOM_TEAM_COLORS is set, use these colors.
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  --    Teal
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   --    Yellow
TEAM_COLORS[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }  --    Pink
TEAM_COLORS[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }   --    Orange
TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }   --    Blue
TEAM_COLORS[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }  --    Green
TEAM_COLORS[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }   --    Brown
TEAM_COLORS[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }  --    Cyan
TEAM_COLORS[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }  --    Olive
TEAM_COLORS[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }  --    Purple

USE_AUTOMATIC_PLAYERS_PER_TEAM = false   -- Should we set the number of players to 10 / MAX_NUMBER_OF_TEAMS?

CUSTOM_TEAM_PLAYER_COUNT = {}           -- If we're not automatically setting the number of players per team, use this table
if GetMapName() == "tcotrpg" then
  MAX_NUMBER_OF_TEAMS = 1
  CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 5 -- you need to set this for each map if maps have a different max number of players per team
  CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 0 -- you need to set this for each map if maps have a different max number of players
end

if GetMapName() == "5v5" then
  MAX_NUMBER_OF_TEAMS = 2
  CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 5 -- you need to set this for each map if maps have a different max number of players per team
  CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 5 -- you need to set this for each map if maps have a different max number of players
end

CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_1] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_2] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_3] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_4] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_6] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_7] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_8] = 0

INT_MAX_LIMIT = 1073741823 -- For max hp etc.
--143 032 032 (143m)
if GetMapName() == "tcotrpg_1v1" then
    MAX_NUMBER_OF_TEAMS = 2
    CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 1 -- you need to set this for each map if maps have a different max number of players per team
    CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 1
end

-- Abilities that can not deal damage to bosses --
DAMAGE_FILTER_BANNED_BOSS_ABILITIES = {
  "phantom_assassin_fan_of_knives", -- Too high damage
  "ancient_apparition_ice_blast", -- Shatter might work on bosses, unsure
  "shadow_demon_soul_catcher", -- Too high damage
  "zuus_static_field", -- Not sure if it's health removal, might be...
  "tinker_shrink_ray", -- No
  "tinker_laser", -- No
  "night_stalker_hunter_in_the_night", -- No
  "doom_bringer_infernal_blade",
  "spectre_dispersion",
}

-- Abilities that cannot target bosses --
BANNED_BOSS_ABILITIES = {
  "tusk_walrus_kick",
  "legion_commander_duel",
  "enchantress_enchant",
  "huskar_life_break",
  "chen_holy_persuasion",
  "snapfire_gobble_up",
  "snapfire_spit_creep",
  "bloodseeker_bloodrage",
  "mirana_arrow",
  "zuus_static_field",
  "vengefulspirit_nether_swap",
  "phantom_assassin_fan_of_knives",
  "life_stealer_feast",
  "life_stealer_open_wounds",
  "life_stealer_infest",
  "doom_bringer_devour",
  "tinker_shrink_ray",
  "pugna_decrepify",
  "ancient_apparition_ice_blast",
  "doom_bringer_infernal_blade",
  "windrunner_powershot",
  "obsidian_destroyer_astral_imprisonment",
  "axe_culling_blade",
  "shadow_demon_disruption",
  "obsidian_destroyer_arcane_orb",
  "item_force_staff",
  "item_hurricane_pike",
  "bloodseeker_rupture",
  "servants_from_below_uba",
  "eternal_damnation",
  "tinker_laser",
  "marci_grapple",
  "night_stalker_hunter_in_the_night"
}

BANNED_BOSS_MODIFIERS = {
  "modifier_abyssal_underlord_atrophy_aura_effect",
  "modifier_razor_eye_of_the_storm_armor",
  "modifier_axe_counter_helix_damage_reduction",
  "modifier_tidehunter_smash_attack"
}

-- Abilities that have their damage reduced by 95% against bosses
-- And creeps that are higher level than you
REDUCED_BOSS_ABILITIES = {
  "death_prophet_spirit_siphon",
  "abyssal_underlord_firestorm",
  "enigma_black_hole",
  "enigma_midnight_pulse", -- Magical, but the amount is too high
  "huskar_life_break", -- Absolutely not, too high damage
  "venomancer_poison_nova", -- Too high damage
  "zaken_stitching_strikes",
  "necrolyte_reapers_scythe",
  --"huskar_burning_spear_custom",
  "jakiro_liquid_ice",
  "bloodseeker_blood_mist_custom",
  "phantom_assassin_fan_of_knives",
  "zuus_static_field",
  "doom_bringer_infernal_blade",
  "spectre_dispersion",
}

BOOK_ABILITY_SELECTION = {
    "gun_joe_explosive",
    "gun_joe_calibrated_shot",
    "abaddon_aphotic_shield",
    "abaddon_death_coil",
    "abyssal_underlord_dark_portal",
    "abyssal_underlord_dark_rift",
    "abyssal_underlord_firestorm",
    "abyssal_underlord_pit_of_malice",
    "alchemist_acid_spray",
    "alchemist_goblins_greed",
    "alchemist_unstable_concoction",
    "ancient_apparition_chilling_touch",
    "ancient_apparition_cold_feet",
    "alchemist_chemical_rage",
    "ancient_apparition_ice_blast",
    "ancient_apparition_ice_vortex",
    "antimage_blink",
    "antimage_counterspell",
    "antimage_mana_overload",
    "antimage_spell_shield",
    "antimage_mana_void",
    "antimage_mana_break",
    "arc_warden_flux",
    "arc_warden_magnetic_field",
    "arc_warden_spark_wraith",
    "axe_battle_hunger",
    "axe_berserkers_call",
    "axe_counter_helix",
    "axe_culling_blade",
    "bane_brain_sap",
    "bane_enfeeble",
    "bane_fiends_grip",
    "bane_nightmare",
    "batrider_firefly",
    "shredder_flamethrower",
    "batrider_flamebreak",
    "batrider_sticky_napalm",
    "beastmaster_call_of_the_wild_boar",
    "beastmaster_call_of_the_wild_hawk",
    "batrider_flaming_lasso",
    "beastmaster_inner_beast",
    "beastmaster_primal_roar",
    "beastmaster_wild_axes",
    "bounty_hunter_jinada",
    "bounty_hunter_shuriken_toss",
    "bounty_hunter_track",
    "brewmaster_cinder_brew",
    "bounty_hunter_wind_walk",
    "brewmaster_drunken_brawler",
    "brewmaster_primal_split",
    "brewmaster_thunder_clap",
    "brewmaster_void_astral_pulse",
    "bristleback_bristleback",
    "bristleback_quill_spray_custom",
    "bristleback_viscous_nasal_goo_custom",
    "bristleback_warpath_custom",
    "broodmother_incapacitating_bite",
    "broodmother_insatiable_hunger",
    "broodmother_poison_sting",
    "broodmother_silken_bola",
    "broodmother_spin_web",
    "broodmother_sticky_snare",
    "centaur_hoof_stomp",
    "centaur_stampede",
    "chaos_knight_chaos_bolt",
    "chaos_knight_chaos_strike",
    "chaos_knight_phantasm",
    "chaos_knight_reality_rift",
    "chen_divine_favor",
    "chen_hand_of_god",
    "chen_holy_persuasion",
    "chen_penitence",
    "chen_test_of_faith",
    "clinkz_death_pact",
    "clinkz_searing_arrows",
    "clinkz_strafe",
    "clinkz_wind_walk",
    "brewmaster_drunken_haze",
    "crystal_maiden_brilliance_aura",
    "crystal_maiden_freezing_field",
    "crystal_maiden_crystal_nova",
    "crystal_maiden_let_it_go",
    "dark_seer_normal_punch",
    "crystal_maiden_frostbite",
    "dark_seer_vacuum",
    "dark_seer_wall_of_replica",
    "dark_seer_ion_shell",
    "dark_willow_bramble_maze",
    "dark_willow_cursed_crown",
    "dark_willow_shadow_realm",
    "dark_willow_terrorize",
    "dark_seer_surge",
    "dazzle_poison_touch",
    "dazzle_rain_of_vermin",
    "dazzle_bad_juju",
    "death_prophet_carrion_swarm",
    "death_prophet_silence",
    "death_prophet_exorcism",
    "disruptor_glimpse",
    "death_prophet_spirit_siphon",
    "disruptor_kinetic_field",
    "disruptor_static_storm",
    "dazzle_shadow_wave",
    "dazzle_good_juju",
    "disruptor_thunder_strike",
    "doom_bringer_doom",
    "dragon_knight_dragon_tail",
    "dragon_knight_fireball",
    "dragon_knight_frost_breath",
    "drow_ranger_marksmanship",
    "drow_ranger_frost_arrows",
    "drow_ranger_multishot",
    "drow_ranger_silence",
    "drow_ranger_wave_of_silence",
    "earth_spirit_boulder_smash",
    "dragon_knight_dragon_blood",
    "earth_spirit_geomagnetic_grip",
    "earth_spirit_petrify",
    "earth_spirit_magnetize",
    "earth_spirit_stone_caller",
    "dragon_knight_breathe_fire",
    "doom_bringer_scorched_earth",
    "earthshaker_echo_slam",
    "earthshaker_enchant_totem",
    "earthshaker_fissure",
    "elder_titan_ancestral_spirit",
    "elder_titan_earth_splitter",
    "elder_titan_echo_stomp",
    "elder_titan_natural_order",
    "ember_spirit_fire_remnant",
    "ember_spirit_searing_chains",
    "ember_spirit_flame_guard",
    "ember_spirit_sleight_of_fist",
    "enchantress_enchant",
    "enchantress_impetus",
    "enchantress_natures_attendants",
    "enchantress_untouchable",
    "enigma_black_hole",
    "earth_spirit_rolling_boulder",
    "earthshaker_aftershock",
    "enigma_demonic_conversion",
    "enigma_malefice",
    "enigma_midnight_pulse",
    "faceless_void_backtrack",
    "faceless_void_time_walk",
    "furion_wrath_of_nature",
    "furion_teleportation",
    "grimstroke_dark_artistry",
    "grimstroke_ink_creature",
    "grimstroke_spirit_walk",
    "gyrocopter_call_down",
    "grimstroke_soul_chain",
    "gyrocopter_homing_missile",
    "gyrocopter_flak_cannon",
    "gyrocopter_rocket_barrage",
    "hoodwink_acorn_shot",
    "hoodwink_bushwhack",
    "hoodwink_sharpshooter",
    "huskar_inner_fire",
    "huskar_inner_vitality",
    "jakiro_dual_breath",
    "jakiro_ice_path",
    "jakiro_liquid_fire",
    "jakiro_macropyre",
    "juggernaut_healing_ward",
    "keeper_of_the_light_chakra_magic",
    "keeper_of_the_light_illuminate",
    "juggernaut_blade_dance",
    "juggernaut_blade_fury",
    "kunkka_ghostship",
    "kunkka_tidebringer",
    "kunkka_torrent",
    "kunkka_x_marks_the_spot",
    "kunkka_tidal_wave",
    "legion_commander_moment_of_courage",
    "legion_commander_overwhelming_odds",
    "leshrac_diabolic_edict",
    "legion_commander_press_the_attack",
    "leshrac_pulse_nova",
    "leshrac_split_earth",
    "leshrac_lightning_storm",
    "lich_chain_frost",
    "lich_frost_shield",
    "lich_frost_nova",
    "lich_sinister_gaze",
    "lina_dragon_slave",
    "life_stealer_open_wounds",
    "lina_light_strike_array",
    "lion_finger_of_death",
    "lina_fiery_soul",
    "lion_mana_drain",
    "lion_impale",
    "lion_voodoo",
    "lone_druid_savage_roar",
    "lone_druid_spirit_bear",
    "lone_druid_rabid",
    "lone_druid_spirit_link",
    "lone_druid_true_form",
    "luna_eclipse",
    "luna_lunar_blessing",
    "luna_moon_glaive",
    "luna_lunar_grace",
    "luna_lucent_beam",
    "magnataur_empower",
    "magnataur_greater_shockwave",
    "magnataur_reverse_polarity",
    "marci_companion_run",
    "magnataur_skewer",
    "magnataur_shockwave",
    "marci_guardian",
    "marci_grapple",
    "mars_arena_of_blood",
    "marci_unleash",
    "mars_bulwark",
    "mars_gods_rebuke",
    "medusa_mystic_snake",
    "mars_spear",
    "medusa_stone_gaze",
    "meepo_earthbind",
    "medusa_split_shot",
    "mirana_invis",
    "mirana_arrow",
    "mirana_starfall",
    "monkey_king_boundless_strike",
    "monkey_king_jingu_mastery",
    "mirana_leap",
    "morphling_adaptive_strike_agi",
    "monkey_king_tree_dance",
    "morphling_adaptive_strike_str",
    "morphling_morph",
    "monkey_king_wukongs_command",
    "morphling_replicate",
    "morphling_waveform",
    "naga_siren_ensnare",
    "naga_siren_song_of_the_siren",
    "necrolyte_death_pulse",
    "necrolyte_death_seeker",
    "naga_siren_mirror_image",
    "necrolyte_sadist",
    "nevermore_requiem",
    "nevermore_dark_lord",
    "nevermore_necromastery",
    "nevermore_shadowraze2",
    "nevermore_shadowraze3",
    "night_stalker_crippling_fear",
    "night_stalker_hunter_in_the_night",
    "night_stalker_darkness",
    "nevermore_shadowraze1",
    "nyx_assassin_mana_burn",
    "nyx_assassin_impale",
    "night_stalker_void",
    "nyx_assassin_spiked_carapace",
    "nyx_assassin_vendetta",
    "obsidian_destroyer_astral_imprisonment",
    "obsidian_destroyer_equilibrium",
    "obsidian_destroyer_sanity_eclipse",
    "ogre_magi_bloodlust",
    "ogre_magi_fireblast",
    "obsidian_destroyer_essence_aura",
    "omniknight_degen_aura",
    "ogre_magi_ignite",
    "omniknight_hammer_of_purity",
    "omniknight_guardian_angel",
    "omniknight_purification",
    "omniknight_pacify",
    "omniknight_martyr",
    "oracle_rain_of_destiny",
    "pangolier_gyroshell",
    "pangolier_heartpiercer",
    "pangolier_lucky_shot",
    "pangolier_rollup",
    "oracle_fortunes_end",
    "pangolier_swashbuckle",
    "omniknight_repel",
    "phantom_assassin_phantom_strike",
    "phantom_assassin_stifling_dagger",
    "phoenix_fire_spirits",
    "phantom_lancer_phantom_edge",
    "phoenix_icarus_dive",
    "phoenix_sun_ray",
    "phoenix_supernova",
    "primal_beast_onslaught",
    "primal_beast_onslaught_release",
    "primal_beast_rock_throw",
    "primal_beast_uproar",
    "puck_dream_coil",
    "puck_ethereal_jaunt",
    "primal_beast_pulverize",
    "puck_phase_shift",
    "puck_illusory_orb",
    "primal_beast_trample",
    "pudge_meat_hook_lua",
    "pugna_decrepify",
    "pugna_life_drain",
    "pugna_nether_blast",
    "pugna_nether_ward",
    "queenofpain_scream_of_pain",
    "puck_waning_rift",
    "queenofpain_sonic_wave",
    "queenofpain_shadow_strike",
    "queenofpain_blink",
    "rattletrap_hookshot",
    "rattletrap_battery_assault",
    "rattletrap_power_cogs",
    "rattletrap_rocket_flare",
    "razor_eye_of_the_storm",
    "razor_static_link",
    "razor_unstable_current",
    "riki_blink_strike",
    "razor_plasma_field",
    "riki_permanent_invisibility",
    "riki_smoke_screen",
    "riki_backstab",
    "riki_tricks_of_the_trade",
    "rubick_arcane_supremacy",
    "rubick_fade_bolt",
    "rubick_null_field",
    "rubick_spell_steal",
    "rubick_telekinesis",
    "shadow_demon_demonic_purge",
    "shadow_demon_demonic_cleanse",
    "shadow_demon_shadow_poison",
    "shadow_demon_disruption",
    "shadow_shaman_ether_shock",
    "shadow_shaman_mass_serpent_ward",
    "shadow_shaman_shackles",
    "timbersaw_chakram_custom",
    "timbersaw_chakram_2_custom",
    "shadow_shaman_voodoo",
    "shadow_demon_soul_catcher",
    "shredder_reactive_armor_custom",
    "shredder_timber_chain",
    "shredder_whirling_death_custom",
    "silencer_global_silence",
    "skeleton_king_hellfire_blast",
    "skeleton_king_mortal_strike",
    "skywrath_mage_arcane_bolt",
    "skywrath_mage_ancient_seal",
    "skeleton_king_vampiric_aura",
    "skywrath_mage_concussive_shot",
    "skywrath_mage_shield_of_the_scion",
    "skywrath_mage_mystic_flare",
    "slardar_amplify_damage",
    "slardar_slithereen_crush",
    "slardar_sprint",
    "slark_dark_pact",
    "slark_pounce",
    "snapfire_firesnap_cookie",
    "snapfire_lil_shredder",
    "snapfire_mortimer_kisses",
    "snapfire_scatterblast",
    "sniper_assassinate",
    "slark_shadow_dance",
    "sniper_headshot",
    "sniper_shrapnel",
    "sniper_take_aim",
    "spirit_breaker_bulldoze",
    "spirit_breaker_empowering_haste",
    "spirit_breaker_charge_of_darkness",
    "storm_spirit_ball_lightning",
    "spirit_breaker_nether_strike",
    "storm_spirit_electric_rave",
    "spirit_breaker_greater_bash",
    "storm_spirit_electric_vortex",
    "storm_spirit_overload",
    "storm_spirit_static_remnant",
    "sven_storm_bolt",
    "sven_great_cleave",
    "techies_reactive_tazer",
    "techies_stasis_trap",
    "techies_suicide",
    "techies_sticky_bomb",
    "templar_assassin_meld",
    "techies_land_mines",
    "sven_warcry",
    "templar_assassin_psi_blades",
    "templar_assassin_psionic_trap",
    "templar_assassin_refraction",
    "templar_assassin_trap",
    "terrorblade_terror_wave",
    "tidehunter_anchor_smash",
    "terrorblade_sunder",
    "tidehunter_gush",
    "tidehunter_kraken_shell",
    "tinker_defense_matrix",
    "tidehunter_ravage",
    "tinker_heat_seeking_missile",
    "terrorblade_demon_zeal",
    "tinker_keen_teleport",
    "tinker_rearm",
    "tiny_avalanche",
    "tinker_march_of_the_machines",
    "tiny_craggy_exterior",
    "tinker_warp_grenade",
    "tiny_grow",
    "tiny_toss",
    "treant_leech_seed",
    "tiny_tree_grab",
    "troll_warlord_battle_trance",
    "troll_warlord_berserkers_rage",
    "troll_warlord_rampage",
    "troll_warlord_fervor",
    "troll_warlord_whirling_axes_melee",
    "tusk_frozen_sigil",
    "troll_warlord_whirling_axes_ranged",
    "treant_overgrowth",
    "tusk_launch_snowball",
    "tusk_ice_shards",
    "tusk_snowball",
    "tusk_tag_team",
    "tusk_walrus_punch",
    "ursa_earthshock",
    "vengefulspirit_command_aura",
    "vengefulspirit_magic_missile",
    "vengefulspirit_nether_swap",
    "venomancer_plague_ward",
    "vengefulspirit_wave_of_terror",
    "ursa_overpower",
    "venomancer_poison_nova",
    "venomancer_poison_sting",
    "ursa_enrage",
    "venomancer_venomous_gale",
    "viper_nethertoxin",
    "viper_poison_attack",
    "viper_corrosive_skin",
    "viper_viper_strike",
    "visage_gravekeepers_cloak",
    "visage_silent_as_the_grave",
    "visage_summon_familiars",
    "void_spirit_aether_remnant",
    "visage_soul_assumption",
    "visage_grave_chill",
    "void_spirit_astral_step",
    "void_spirit_resonant_pulse",
    "void_spirit_dissimilate",
    "warlock_rain_of_chaos",
    "warlock_fatal_bonds",
    "warlock_upheaval",
    "weaver_geminate_attack",
    "weaver_the_swarm",
    "warlock_shadow_word",
    "weaver_shukuchi",
    "weaver_time_lapse",
    "windrunner_windrun",
    "winter_wyvern_cold_embrace",
    "winter_wyvern_splinter_blast",
    "winter_wyvern_arctic_burn",
    "windrunner_shackleshot",
    "wisp_overcharge",
    "winter_wyvern_winters_curse",
    "wisp_relocate",
    "witch_doctor_death_ward",
    "wisp_spirits",
    "witch_doctor_maledict",
    "witch_doctor_paralyzing_cask",
    "witch_doctor_voodoo_restoration",
    "wisp_tether",
    "zuus_arc_lightning",
    "zuus_heavenly_jump",
    "zuus_lightning_bolt",
    "zuus_thundergods_wrath",
    "dazzle_shadow_step",
    "silencer_glaives_of_wisdom_custom",
    "silencer_growing_intellect_custom",
    "bloodseeker_bloodrage_custom",
    "bloodseeker_thirst_custom",
    "bloodseeker_blood_mist_custom",
    "bloodseeker_rupture_custom",
    "furion_living_roots_custom",
    "furion_breezing_wind_custom",
    "undying_infection_custom",
    "undying_consume_custom",
    "undying_grave_custom",
    "undying_flesh_golem_custom",
    "undying_frenzy_custom",
    "eternal_damnation_uba",
    "servants_from_below_uba",
    "phantom_assassin_coup_de_grace_custom",
    "oracle_fortunes_end_custom",
    "oracle_backtrack",
    "oracle_rain_of_destiny",
    "oracle_blessing",
    "lina_laguna_blade_custom",
    "treant_bark_custom",
    "treant_overgrowth_custom",
    "windranger_powershot_custom",
    "windranger_focus_fire_custom",
    "centaur_double_edge_custom",
    "centaur_return_custom",
    "terrorblade_terror_slash",
    "terrorblade_true_power_custom",
    "slark_essence_shift_custom",
    "huskar_double_throw_custom",
    "huskar_berserkers_blood_custom",
    "spectre_phase_custom",
    "spectre_vengeance_custom",
    "faceless_void_time_lock_custom",
    "legion_commander_duel_custom",
    "stargazer_gamma_ray",
    "stargazer_inverse_field",
    "zaken_stitching_strikes",
    "zaken_last_chance",
    "zaken_summon_sailors",
    "zaken_sword_control",
    "stegius_desolus_wave",
    "stegius_rage_of_desolus",
    "stegius_brightness_of_desolate",
    "drow_ranger_sharp_arrow_custom",
    "dawnbreaker_solar_hammer",
}

-- Abilities that won't be randomly given to players
BOOK_ABILITY_SELECTION_EXCEPTIONS = {
  "shredder_return_chakram",
  "shredder_return_chakram_2",
  "morphling_morph_str",
  "morphling_morph_agi",
  "obsidian_destroyer_arcane_orb",
  "undying_consume_custom",
  "slark_essence_shift_custom",
  "terrorblade_true_power_custom",
  "legion_commander_duel_custom",
  "silencer_growing_intellect_custom",
  "bloodseeker_thirst_custom",
  "phantom_assassin_coup_de_grace_custom",
  "snapfire_kisses_custom",
  "undying_infection_custom",
  "undying_grave_custom",
  "undying_flesh_golem_custom",
  "undying_frenzy_custom",
  "tinker_rearm",
  "ogre_magi_multicast_custom",
  "lina_laguna_blade_custom",
  "spectre_desolate_custom",
  "slardar_bash_of_the_deep_custom",
  "timbersaw_chakram_custom",
  "timbersaw_chakram_2_custom",
  "timbersaw_return_chakram_custom",
  "timbersaw_return_chakram_2_custom",
  "drow_ranger_marksmanship",
  "faceless_void_chronosphere_custom",
  "weaver_geminate_attack",
  "silencer_glaives_of_wisdom_custom",
  "axe_helix_proc_custom",
  "centaur_double_edge_custom",
  "dazzle_good_juju",
  "monkey_king_wukongs_command",
  "bloodseeker_bloodrage_custom",
  "dawnbreaker_solar_hammer_replace",
  "dawnbreaker_luminosity_custom_daybreak",
  "pangolier_lucky_shot",
  "pangolier_heartpiercer",
  "mars_bulwark",
  "snapfire_lil_shredder",
  "huskar_burning_spear_custom",
}

-- Abilities you can't change or replace
BOOK_ABILITY_CHANGE_PROHIBITED = {
  "timbersaw_return_chakram_custom",
  "timbersaw_return_chakram_2_custom",
  "lion_agony",
  "lion_finger_of_death_custom",
  "axe_helix_proc_custom",
  "morphling_morph_str",
  "morphling_morph_agi",
  "undying_consume_custom",
  "slark_essence_shift_custom",
  "terrorblade_true_power_custom",
  "legion_commander_duel_custom",
  "silencer_growing_intellect_custom",
  "bloodseeker_thirst_custom",
  "phantom_assassin_coup_de_grace_custom",
  "monkey_king_wukongs_command",
  "juggernaut_omnislash_custom",
  "dawnbreaker_luminosity_custom",
  "dawnbreaker_luminosity_custom_daybreak",
  "dawnbreaker_solar_hammer_replace",
  "abyssal_underlord_atrophy_aura",
  "pudge_hunger_custom",
  "pudge_flesh_heap_custom",
  "monkey_king_boundless_strike_stack_custom",
  "monkey_king_wukongs_command_custom",
  "monkey_king_primal_spring_early",
  "monkey_king_untransform",
  "monkey_king_boundless_passive_proc_custom",
  "timbersaw_chakram_2_custom",
  "timbersaw_chakram_custom",
  "shredder_return_chakram",
  "shredder_return_chakram_2",
}

-- EASY --
PLAYER_EASY_BUFFS = {
  "modifier_player_difficulty_buff_gold_50", -- +50% gold on kill
  "modifier_player_difficulty_buff_heal_on_kill_25", -- heals for 25% of targets hp on kill
  "modifier_player_difficulty_buff_damage_reduction_50", -- 50% damage reduction
  "modifier_player_difficulty_buff_armor_50", -- +50 bonus armor
  "modifier_player_difficulty_buff_damage_25", -- +25% outgoing damage
  "modifier_player_difficulty_buff_bounty_rune_200", -- +200% bounty rune gold and xp
}

-- NORMAL --
PLAYER_NORMAL_BUFFS = {
  "modifier_player_difficulty_buff_gold_10", -- +10% gold on kill
  "modifier_player_difficulty_buff_heal_on_kill_10", -- heals for 10% of targets hp on kill
  "modifier_player_difficulty_buff_bounty_rune_50", -- +50% bounty rune gold and xp
}

ENEMY_NORMAL_BUFFS = {
  "modifier_enemy_difficulty_buff_death_explosion_10", -- Deals 10% of max hp to nearby heroes on death
  "modifier_enemy_difficulty_buff_extra_attack_10", -- Extra attack with 10s cooldown
  "modifier_enemy_difficulty_buff_hp_regen_pct_1", -- 1% max hp regen
}

-- HARD --
PLAYER_HARD_BOONS = {
  "modifier_player_difficulty_boon_reduced_healing_40", -- 50% reduced healing
  "modifier_player_difficulty_boon_health_drain_1", -- 1% health drain
  "modifier_player_difficulty_boon_misfire_30", -- 30% chance to summon an evil shadow to attack you
  "modifier_player_difficulty_boon_blinded_30", -- 30% chance to miss your attacks and reduced vision
  "modifier_player_difficulty_boon_leaky_1", -- When losing HP or Mana, you gradually lose an additional -1% of it for a few sec.
  "modifier_player_difficulty_boon_weapon_destruction_30", -- 30% chance for a random item in your inventory (not backpack or stash) to be deleted
  "modifier_player_difficulty_boon_disarm_30", -- 30% to disarm self on attack. 10s cd
  "modifier_player_difficulty_boon_hex_30", -- 30% to hex self when dealing magical/pure damage. 10s cd
  "modifier_player_difficulty_boon_self_death_explosion_60", -- explodes on death, dealing damage to allies
}

ENEMY_HARD_BUFFS = {
  "modifier_enemy_difficulty_buff_death_explosion_15", -- Deals 25% of max hp to nearby heroes on death
  "modifier_enemy_difficulty_buff_hp_regen_pct_1_5", -- 1% max hp regen
  "modifier_enemy_difficulty_buff_petrify_10", -- 20% chance to petrify you on attack
  "modifier_enemy_difficulty_buff_attack_speed_missing_hp_50", -- Gains attack speed based on missing health, max 50% increase
  "modifier_enemy_difficulty_buff_mana_burn_5", -- Each hit burns 5% of the targets max mana
  "modifier_enemy_difficulty_buff_magical_damage_40", -- 40% of attack damage is dealt as bonus magical damage
  "modifier_enemy_difficulty_buff_reverse_taunt_5",
  "modifier_enemy_difficulty_buff_steal_damage_10"
}

-- UNFAIR --
PLAYER_UNFAIR_BOONS = {
  "modifier_player_difficulty_boon_reduced_healing_50", -- 50% reduced healing
  "modifier_player_difficulty_boon_health_drain_5", -- 5% health drain
  "modifier_player_difficulty_boon_misfire_50", -- 50% chance to summon an evil shadow to attack you
  "modifier_player_difficulty_boon_random_speed_debuffs_30_60", -- 30% chance every second to have speed and attack speed reduced by 90%
  "modifier_player_difficulty_boon_ally_proximity_debuff_1", -- When near another hero, you lose 1% of your max health per second (stacks)
  "modifier_player_difficulty_boon_blinded_no_vision_50", -- 50% chance to miss your attacks and vision impacted
  "modifier_player_difficulty_boon_leaky_2_5", -- When losing HP or Mana, you gradually lose an additional -2.5% of it for a few sec.
}

ENEMY_UNFAIR_BUFFS = {
  "modifier_enemy_difficulty_buff_death_explosion_20", -- Deals 25% of max hp to nearby heroes on death
  "modifier_enemy_difficulty_buff_petrify_40", -- 20% chance to petrify you on attack (3s cd)
  "modifier_enemy_difficulty_buff_attack_speed_missing_hp_80", -- Gains attack speed based on missing health, max 50% increase
  "modifier_enemy_difficulty_buff_mana_burn_5", -- Each hit burns 5% of the targets max mana
  "modifier_enemy_difficulty_buff_wraith_5_20", -- Enemies turn into wraiths on death that regenerates 5% hp over 20s
  "modifier_enemy_difficulty_buff_crit_chance_60", -- 60% chance to crit
}

PLAYER_IMPOSSIBLE_BOONS = {
  "modifier_player_difficulty_boon_reduced_healing_and_health_drain_5_75", -- 75% reduced healing, regeneration and lifesteal
  "modifier_player_difficulty_boon_blinded_no_vision_50", -- 50% chance to miss your attacks and vision impacted
  "modifier_player_difficulty_boon_leaky_5",
  "modifier_player_difficulty_boon_random_speed_debuffs_30_60", -- 30% chance every second to have speed and attack speed reduced by 90%
  "modifier_player_difficulty_boon_weapon_destruction_30", -- 30% chance for a random item in your inventory (not backpack or stash) to be deleted
  "modifier_player_difficulty_boon_disarm_30", -- 30% to disarm self on attack. 10s cd
  "modifier_player_difficulty_boon_hex_30", -- 30% to hex self when dealing magical/pure damage. 10s cd
  "modifier_player_difficulty_boon_self_death_explosion_60", -- explodes on death, dealing damage to allies
}

ENEMY_IMPOSSIBLE_BUFFS = {
  "modifier_enemy_difficulty_buff_mana_burn_5", -- Each hit burns 5% of the targets max mana
  "modifier_enemy_difficulty_buff_wraith_5_10", -- Enemies turn into wraiths on death that regenerates 5% hp over 10s
  "modifier_enemy_difficulty_buff_magical_damage_40", -- 40% of attack damage is dealt as bonus magical damage
  "modifier_enemy_difficulty_buff_death_explosion_30",
  "modifier_enemy_difficulty_buff_petrify_60",
  "modifier_enemy_difficulty_buff_attack_speed_missing_hp_80",
  "modifier_enemy_difficulty_buff_reverse_taunt_5",
  "modifier_enemy_difficulty_buff_steal_damage_10"
}

PLAYER_HELL_BOONS = PLAYER_IMPOSSIBLE_BOONS
ENEMY_HELL_BUFFS = ENEMY_IMPOSSIBLE_BUFFS

PLAYER_HARDCORE_BOONS = {
  "modifier_player_difficulty_boon_reduced_healing_and_health_drain_5_75", -- 75% reduced healing, regeneration and lifesteal
  "modifier_player_difficulty_boon_blinded_no_vision_50", -- 50% chance to miss your attacks and vision impacted
  "modifier_player_difficulty_boon_leaky_5",
  "modifier_player_difficulty_boon_random_speed_debuffs_30_60", -- 30% chance every second to have speed and attack speed reduced by 90%
  "modifier_player_difficulty_boon_disarm_30", -- 30% to disarm self on attack. 10s cd
  "modifier_player_difficulty_boon_hex_30", -- 30% to hex self when dealing magical/pure damage. 10s cd
  "modifier_player_difficulty_boon_self_death_explosion_60", -- explodes on death, dealing damage to allies
}
ENEMY_HARDCORE_BUFFS = ENEMY_IMPOSSIBLE_BUFFS

NEUTRAL_ITEM_DROP_TABLE_COMMON = {
    "item_keen_optic",
    "item_ironwood_tree",
    "item_ocean_heart",
    "item_broom_handle",
    "item_faded_broach",
    "item_arcane_ring",
    "item_chipped_vest",
    "item_possessed_mask",
    "item_mysterious_hat",
    "item_philosophers_stone",
    "item_unstable_wand",
    "item_pogo_stick",
    "item_paintball",
    "item_royal_jelly"
}

NEUTRAL_ITEM_DROP_TABLE_UNCOMMON = {
    "item_quickening_charm",
    "item_dragon_scale",
    "item_spider_legs",
    "item_pupils_gift",
    "item_imp_claw",
    "item_orb_of_destruction",
    "item_titan_sliver",
    "item_mind_breaker",
    "item_enchanted_quiver",
    "item_elven_tunic",
    "item_psychic_headband",
    "item_black_powder_bag",
    "item_vambrace",
    "item_misericorde",
    "item_quicksilver_amulet",
    "item_essence_ring",
    "item_nether_shawl",
    "item_bullwhip",
}

NEUTRAL_ITEM_DROP_TABLE_RARE = {
    "item_flicker",
    "item_ninja_gear",
    "item_the_leveller",
    "item_minotaur_horn",
    "item_spy_gadget",
    "item_trickster_cloak",
    "item_stormcrafter",
    "item_penta_edged_sword",
    "item_ascetic_cap",
    "item_illusionsts_cape"
}

NEUTRAL_ITEM_DROP_TABLE_LEGENDARY = {
    "item_desolator_2",
    "item_seer_stone",
    "item_mirror_shield",
    "item_apex",
    "item_demonicon",
    "item_fallen_sky",
    "item_ex_machina",
    "item_giants_ring",
    "item_book_of_shadows",
    "item_timeless_relic",
    "item_spell_prism",
}

ENEMY_ALL_BUFFS = ENEMY_HARD_BUFFS

PLAYER_ALL_BOONS = PLAYER_HARD_BOONS

--

-- Modifiers that wont be removed from bosses
STACKING_MODIFIERS_EXCEPTION = {
  "modifier_ursa_fury_swipes_custom_swipe",
  "modifier_bristleback_quill_spray_custom",
  "modifier_bristleback_quill_spray_custom_stack",
  "modifier_viper_poison_attack",
  "modifier_bloodseeker_rupture_custom_debuff",
  "modifier_stegius_desolating_touch_debuff"
}
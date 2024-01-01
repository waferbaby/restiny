# frozen_string_literal: true

module Restiny
  # Definitions for the gaming platforms supported by Destiny 2.
  module Platform
    ALL = -1
    XBOX = 1
    PSN = 2
    STEAM = 3
    EPIC = 6

    def self.all
      {
        ALL => 'All',
        XBOX => 'Xbox',
        PSN => 'PSN',
        STEAM => 'Steam',
        EPIC => 'Epic'
      }
    end
  end

  # Definitions for the possible locations an item can be related to a character.
  module ItemLocation
    INVENTORY = 1
    VAULT = 2
    VENDOR = 3
    POSTMASTER = 4

    def self.all
      {
        INVENTORY => 'Inventory',
        VAULT => 'Vault',
        VENDOR => 'Vendor',
        POSTMASTER => 'Postmaster'
      }
    end
  end

  # Definitions for the tier/rarity of a particular item.
  module TierType
    CURRENCY = 1
    BASIC = 2
    COMMON = 3
    RARE = 4
    LEGENDARY = 5
    EXOTIC = 6

    def self.all
      {
        CURRENCY => 'Currency',
        BASIC => 'Basic',
        COMMON => 'Common',
        RARE => 'Rare',
        LEGENDARY => 'Legendary',
        EXOTIC => 'Exotic'
      }
    end
  end

  # Definitions for a Guardian's class.
  module GuardianClass
    TITAN = 0
    HUNTER = 1
    WARLOCK = 2
    ANY = 3

    def self.all
      {
        TITAN => 'Titan',
        HUNTER => 'Hunter',
        WARLOCK => 'Warlock',
        ANY => 'Any'
      }
    end
  end

  # Definitions for a Guardian's race.
  module Race
    HUMAN = 0
    AWOKEN = 1
    EXO = 2

    def self.all
      {
        HUMAN => 'Human',
        AWOKEN => 'Awoken',
        EXO => 'Exo'
      }
    end
  end

  # Definitions for a Guardian's gender.
  module Gender
    MASCULINE = 0
    FEMININE = 1

    def self.all
      {
        MASCULINE => 'Masculine',
        FEMININE => 'Feminine'
      }
    end
  end

  # Definitions for the Champion breaker types used in the game.
  module BreakerType
    SHIELD_PIERCING = 1
    DISRUPTION = 2
    STAGGER = 3

    def self.all
      {
        SHIELD_PIERCING => 'Shield-Piercing',
        DISRUPTION => 'Disruption',
        STAGGER => 'Stagger'
      }
    end
  end

  # Definitions for the various types of ammunition used in the game.
  module Ammunition
    PRIMARY = 1
    SPECIAL = 2
    HEAVY = 3

    def self.all
      {
        PRIMARY => 'Primary',
        SPECIAL => 'Special',
        HEAVY => 'Heavy'
      }
    end
  end

  # Definitions for the various damage types in the game.
  module DamageType
    KINETIC = 1
    ARC = 2
    SOLAR = 3
    VOID = 4
    RAID = 5
    STASIS = 6
    STRAND = 7

    def self.all
      {
        KINETIC => 'Kinetic',
        ARC => 'Arc',
        SOLAR => 'Solar',
        VOID => 'Void',
        RAID => 'Raid',
        STASIS => 'Stasis',
        STRAND => 'Strand'
      }
    end
  end

  # Definitions for the slots a weapon can be placed in.
  module WeaponSlot
    KINETIC_SLOT = 1
    ENERGY_SLOT = 2
    POWER_SLOT = 3

    def self.all
      {
        KINETIC_SLOT => 'Kinetic',
        ENERGY_SLOT => 'Energy',
        POWER_SLOT => 'Power'
      }
    end
  end

  # Definitions for the various gear-related groups within Destiny 2.
  module Faction
    CRUCIBLE = 1
    DEAD_ORBIT = 2
    FUTURE_WAR_CULT = 3
    NEW_MONARCHY = 4
    VANGUARD = 5

    def self.all
      {
        CRUCIBLE => 'Crucible',
        DEAD_ORBIT => 'Dead Orbit',
        FUTURE_WAR_CULT => 'Future War Cult',
        NEW_MONARCHY => 'New Monarchy',
        VANGUARD => 'Vanguard'
      }
    end

    def self.mapping
      {
        'faction.crucible' => CRUCIBLE,
        'faction.dead_orbit' => DEAD_ORBIT,
        'faction.future_war_cult' => FUTURE_WAR_CULT,
        'faction.new_monarchy' => NEW_MONARCHY,
        'faction.vanguard' => VANGUARD
      }
    end
  end

  # Definitions for the weapon manufacturers in Destiny 2.
  module Foundry
    DAITO = 1
    FIELD_FORGED = 2
    FOTC = 3
    HAKKE = 4
    OMOLON = 5
    SUROS = 6
    TEX_MECHANICA = 7
    VEIST = 8

    def self.all
      {
        DAITO => 'Daito',
        FIELD_FORGED => 'Field Forged',
        FOTC => 'Forces of the City',
        HAKKE => 'Häkke',
        OMOLON => 'Omolon',
        SUROS => 'SUROS',
        TEX_MECHANICA => 'Tex Mechanica',
        VEIST => 'VEIST'
      }
    end

    def self.mapping
      {
        'foundry.daito' => DAITO,
        'foundry.field_forged' => FIELD_FORGED,
        'foundry.fotc' => FOTC,
        'foundry.hakke' => HAKKE,
        'foundry.omolon' => OMOLON,
        'foundry.suros' => SUROS,
        'foundry.tex_mechanica' => TEX_MECHANICA,
        'foundry.veist' => VEIST
      }
    end
  end

  # Definitions for the various types of armour in the game.
  module ArmorType
    ARM = 1
    CHEST = 2
    CLASS_ITEM = 3
    HEAD = 4
    LEG = 5

    def self.all
      {
        ARM => 'Gauntlet',
        CHEST => 'Chest',
        CLASS_ITEM => 'Class Item',
        HEAD => 'Helmet',
        LEG => 'Leg'
      }
    end

    def self.mapping
      {
        'item.armor.arms' => ARM,
        'item.armor.chest' => CHEST,
        'item.armor.class' => CLASS_ITEM,
        'item.armor.head' => HEAD,
        'item.armor.legs' => LEG
      }
    end
  end

  # Definitions for the various types of weapons in the game.
  module WeaponType
    AUTO_RIFLE = 1
    BOW = 2
    FUSION_RIFLE = 3
    GLAIVE = 4
    GRENADE_LAUNCHER = 5
    HAND_CANON = 6
    LINEAR_FUSION_RIFLE = 7
    MACHINE_GUN = 8
    PULSE_RIFLE = 9
    ROCKET_LAUNCHER = 10
    SCOUT_RIFLE = 11
    SHOTGUN = 12
    SIDEARM = 13
    SNIPER_RIFLE = 14
    SUBMACHINE_GUN = 15
    SWORD = 16
    TRACE_RIFLE = 17

    def self.all
      {
        AUTO_RIFLE => 'Auto Rifle',
        BOW => 'Bow',
        FUSION_RIFLE => 'Fusion Rifle',
        GLAIVE => 'Glaive',
        GRENADE_LAUNCHER => 'Grenade Launcher',
        HAND_CANON => 'Hand Canon',
        LINEAR_FUSION_RIFLE => 'Linear Fusion Rifle',
        MACHINE_GUN => 'Machine Gun',
        PULSE_RIFLE => 'Pulse Rifle',
        ROCKET_LAUNCHER => 'Rocket Launcher',
        SCOUT_RIFLE => 'Scout Rifle',
        SHOTGUN => 'Shotgun',
        SIDEARM => 'Sidearm',
        SNIPER_RIFLE => 'Sniper Rifle',
        SUBMACHINE_GUN => 'Submachine Gun',
        SWORD => 'Sword',
        TRACE_RIFLE => 'Trace Rifle'
      }
    end

    def self.mapping
      {
        'item.weapon.auto_rifle' => AUTO_RIFLE,
        'item.weapon.bow' => BOW,
        'item.weapon.fusion_rifle' => FUSION_RIFLE,
        'item.weapon.glaive' => GLAIVE,
        'item.weapon.grenade_launcher' => GRENADE_LAUNCHER,
        'item.weapon.hand_cannon' => HAND_CANON,
        'item.weapon.linear_fusion_rifle' => LINEAR_FUSION_RIFLE,
        'item.weapon.machinegun' => MACHINE_GUN,
        'item.weapon.pulse_rifle' => PULSE_RIFLE,
        'item.weapon.rocket_launcher' => ROCKET_LAUNCHER,
        'item.weapon.scout_rifle' => SCOUT_RIFLE,
        'item.weapon.shotgun' => SHOTGUN,
        'item.weapon.sidearm' => SIDEARM,
        'item.weapon.sniper_rifle' => SNIPER_RIFLE,
        'item.weapon.submachinegun' => SUBMACHINE_GUN,
        'item.weapon.sword' => SWORD,
        'item.weapon.trace_rifle' => TRACE_RIFLE
      }
    end
  end

  # Definitions for the various component types used when requesting a profile entry.
  module ComponentType
    PROFILES = '100'
    VENDOR_RECEIPTS = '101'
    PROFILE_INVENTORIES = '102'
    PROFILE_CURRENCIES = '103'
    PROFILE_PROGRESSION = '104'
    PLATFORM_SILVER = '105'
    CHARACTERS = '200'
    CHARACTER_INVENTORIES = '201'
    CHARACTER_PROGRESSIONS = '202'
    CHARACTER_RENDERDATA = '203'
    CHARACTER_ACTIVITIES = '204'
    CHARACTER_EQUIPMENT = '205'
    CHARACTER_LOADOUTS = '206'
    ITEM_INSTANCES = '300'
    ITEM_OBJECTIVES = '301'
    ITEM_PERKS = '302'
    ITEM_RENDER_DATA = '303'
    ITEM_STATS = '304'
    ITEM_SOCKETS = '305'
    ITEM_TALENT_GRIDS = '306'
    ITEM_COMMON_DATA = '307'
    ITEM_PLUG_STATES = '308'
    ITEM_PLUG_OBJECTIVES = '309'
    ITEM_REUSABLE_PLUGS = '310'
    VENDORS = '400'
    VENDOR_CATEGORIES = '401'
    VENDOR_SALES = '402'
    KIOSKS = '500'
    CURRENCY_LOOKUPS = '600'
    PRESENTATION_NODES = '700'
    COLLECTIBLES = '800'
    RECORDS = '900'
    TRANSITORY = '1000'
    METRICS = '1100'
    STRING_VARIABLES = '1200'
    CRAFTABLES = '1300'
    SOCIAL_COMMENDATIONS = '1400'
  end

  module SocketPlugSource
    NONE = 0
    INVENTORY_SOURCED = 1
    REUSABLE_PLUG_ITEMS = 2
    PROFILE_PLUG_SET = 4
    CHARACTER_PLUG_SET = 8

    def self.sources_for_value(value)
      [].tap do |sources|
        constants.each do |source|
          source_value = const_get(source)
          sources << source_value if (value & source_value) != 0
        end
      end
    end
  end

  # The categories of data stored in the manifest.
  module ManifestDefinition
    def self.values
      constants.map { |c| const_get(c) }
    end

    ACHIEVEMENT = 'DestinyAchievementDefinition'
    ACTIVITY = 'DestinyActivityDefinition'
    ACTIVITY_GRAPH = 'DestinyActivityGraphDefinition'
    ACTIVITY_INTERACTABLE = 'DestinyActivityInteractableDefinition'
    ACTIVITY_MODE = 'DestinyActivityModeDefinition'
    ACTIVITY_MODIFIER = 'DestinyActivityModifierDefinition'
    ACTIVITY_TYPE = 'DestinyActivityTypeDefinition'
    ART_DYE_CHANNEL = 'DestinyArtDyeChannelDefinition'
    ART_DYE_REFERENCE = 'DestinyArtDyeReferenceDefinition'
    ARTIFACT = 'DestinyArtifactDefinition'
    BOND = 'DestinyBondDefinition'
    BREAKER_TYPE = 'DestinyBreakerTypeDefinition'
    CHARACTER_CUSTOMIZATION_CATEGORY = 'DestinyCharacterCustomizationCategoryDefinition'
    CHARACTER_CUSTOMIZATION_OPTION = 'DestinyCharacterCustomizationOptionDefinition'
    CHECKLIST = 'DestinyChecklistDefinition'
    CLASS = 'DestinyClassDefinition'
    COLLECTIBLE = 'DestinyCollectibleDefinition'
    DAMAGE_TYPE = 'DestinyDamageTypeDefinition'
    DESTINATION = 'DestinyDestinationDefinition'
    ENERGY_TYPE = 'DestinyEnergyTypeDefinition'
    ENTITLEMENT_OFFER = 'DestinyEntitlementOfferDefinition'
    EQUIPMENT_SLOT = 'DestinyEquipmentSlotDefinition'
    EVENT_CARD = 'DestinyEventCardDefinition'
    FACTION = 'DestinyFactionDefinition'
    GENDER = 'DestinyGenderDefinition'
    GUARDIAN_RANK_CONSTANTS = 'DestinyGuardianRankConstantsDefinition'
    GUARDIAN_RANK = 'DestinyGuardianRankDefinition'
    INVENTORY_BUCKET = 'DestinyInventoryBucketDefinition'
    INVENTORY_ITEM = 'DestinyInventoryItemDefinition'
    INVENTORY_ITEM_LITE = 'DestinyInventoryItemLiteDefinition'
    ITEM_CATEGORY = 'DestinyItemCategoryDefinition'
    ITEM_TIER_TYPE = 'DestinyItemTierTypeDefinition'
    LOADOUT_COLOR = 'DestinyLoadoutColorDefinition'
    LOADOUT_CONSTANTS = 'DestinyLoadoutConstantsDefinition'
    LOADOUT_ICON = 'DestinyLoadoutIconDefinition'
    LOADOUT_NAME = 'DestinyLoadoutNameDefinition'
    LOCATION = 'DestinyLocationDefinition'
    LORE = 'DestinyLoreDefinition'
    MATERIAL_REQUIREMENT_SET = 'DestinyMaterialRequirementSetDefinition'
    MEDAL_TIER = 'DestinyMedalTierDefinition'
    METRIC = 'DestinyMetricDefinition'
    MILESTONE = 'DestinyMilestoneDefinition'
    NODE_STEP_SUMMARY = 'DestinyNodeStepSummaryDefinition'
    OBJECTIVE = 'DestinyObjectiveDefinition'
    PLACE = 'DestinyPlaceDefinition'
    PLATFORM_BUCKET_MAPPING = 'DestinyPlatformBucketMappingDefinition'
    PLUG_SET = 'DestinyPlugSetDefinition'
    POWER_CAP = 'DestinyPowerCapDefinition'
    PRESENTATION_NODE = 'DestinyPresentationNodeDefinition'
    PROGRESSION = 'DestinyProgressionDefinition'
    PROGRESSION_LEVEL_REQUIREMENT = 'DestinyProgressionLevelRequirementDefinition'
    PROGRESSION_MAPPING = 'DestinyProgressionMappingDefinition'
    RACE = 'DestinyRaceDefinition'
    RECORD = 'DestinyRecordDefinition'
    REPORT_REASON_CATEGORY = 'DestinyReportReasonCategoryDefinition'
    REWARD_ADJUSTER_POINTER = 'DestinyRewardAdjusterPointerDefinition'
    REWARD_ADJUSTER_PROGRESSION_MAP = 'DestinyRewardAdjusterProgressionMapDefinition'
    REWARD_ITEM_LIST = 'DestinyRewardItemListDefinition'
    REWARD_MAPPING = 'DestinyRewardMappingDefinition'
    REWARD_SHEET = 'DestinyRewardSheetDefinition'
    REWARD_SOURCE = 'DestinyRewardSourceDefinition'
    SACK_REWARD_ITEM_LIST = 'DestinySackRewardItemListDefinition'
    SANDBOX_PATTERN = 'DestinySandboxPatternDefinition'
    SANDBOX_PERK = 'DestinySandboxPerkDefinition'
    SEASON = 'DestinySeasonDefinition'
    SEASON_PASS = 'DestinySeasonPassDefinition'
    SOCIAL_COMMENDATION = 'DestinySocialCommendationDefinition'
    SOCIAL_COMMENDATION_NODE = 'DestinySocialCommendationNodeDefinition'
    SOCKET_CATEGORY = 'DestinySocketCategoryDefinition'
    SOCKET_TYPE = 'DestinySocketTypeDefinition'
    STAT = 'DestinyStatDefinition'
    STAT_GROUP = 'DestinyStatGroupDefinition'
    TALENT_GRID = 'DestinyTalentGridDefinition'
    TRAIT = 'DestinyTraitDefinition'
    UNLOCK_COUNT_MAPPING = 'DestinyUnlockCountMappingDefinition'
    UNLOCK = 'DestinyUnlockDefinition'
    UNLOCK_EVENT = 'DestinyUnlockEventDefinition'
    UNLOCK_EXPRESSION_MAPPING = 'DestinyUnlockExpressionMappingDefinition'
    UNLOCK_VALUE = 'DestinyUnlockValueDefinition'
    VENDOR = 'DestinyVendorDefinition'
    VENDOR_GROUP = 'DestinyVendorGroupDefinition'
  end
end

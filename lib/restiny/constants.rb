# frozen_string_literal: true

module Restiny
  # Definitions for the gaming platforms supported by Destiny 2.
  module Platform
    ALL = -1
    XBOX = 1
    PSN = 2
    STEAM = 3
    EPIC = 6

    def self.names
      {
        ALL => 'All',
        XBOX => 'Xbox',
        PSN => 'PSN',
        STEAM => 'Steam',
        EPIC => 'Epic'
      }
    end
  end

  module ItemLocation
    # Definitions for the possible locations an item can be related to a character.
    UNKNOWN = 0
    INVENTORY = 1
    VAULT = 2
    VENDOR = 3
    POSTMASTER = 4

    def self.names
      {
        UNKNOWN => 'Unknown',
        INVENTORY => 'Inventory',
        VAULT => 'Vault',
        VENDOR => 'Vendor',
        POSTMASTER => 'Postmaster'
      }
    end
  end

  # Definitions for the tier/rarity of a particular item.
  module TierType
    UNKNOWN = 0
    CURRENCY = 1
    BASIC = 2
    COMMON = 3
    RARE = 4
    SUPERIOR = 5
    EXOTIC = 6

    def self.names
      {
        UNKNOWN => 'Unknown',
        CURRENCY => 'Currency',
        BASIC => 'Basic',
        COMMON => 'Common',
        RARE => 'Rare',
        SUPERIOR => 'Superior',
        EXOTIC => 'Exotic'
      }
    end
  end

  # Definitions for a Guardian's class.
  module GuardianClass
    TITAN = 0
    HUNTER = 1
    WARLOCK = 2
    UNKNOWN = 3

    def self.names
      {
        TITAN => 'Titan',
        HUNTER => 'Hunter',
        WARLOCK => 'Warlock',
        UNKNOWN => 'Unknown'
      }
    end
  end

  # Definitions for a Guardian's race.
  module Race
    HUMAN = 0
    AWOKEN = 1
    EXO = 2
    UNKNOWN = 3

    def self.names
      {
        HUMAN => 'Human',
        AWOKEN => 'Awoken',
        EXO => 'Exo',
        UNKNOWN => 'Unknown'
      }
    end
  end

  # Definitions for a Guardian's gender.
  module Gender
    MASCULINE = 0
    FEMININE = 1
    UNKNOWN = 2

    def self.names
      {
        MASCULINE => 'Masculine',
        FEMININE => 'Feminine',
        UNKNOWN => 'Unknown'
      }
    end
  end

  # Definitions for the various types of ammunition used in the game.
  module Ammunition
    NONE = 0
    PRIMARY = 1
    SPECIAL = 2
    HEAVY = 3
    UNKNOWN = 4

    def self.names
      {
        NONE => 'None',
        PRIMARY => 'Primary',
        SPECIAL => 'Special',
        HEAVY => 'Heavy',
        UNKNOWN => 'Unknown'
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

  # The categories of data stored in the manifest.
  module ManifestDefinition
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

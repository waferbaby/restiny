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

  # Definitions for the various typos of ammunition in the game.
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
    CHARACTERS = 'Characters'
    CHARACTER_EQUIPMENT = 'CharacterEquipment'
    CHARACTER_INVENTORIES = 'CharacterInventories'
    CHARACTER_LOADOUTS = 'CharacterLoadouts'
    PROFILES = 'Profiles'
    PROFILE_INVENTORIES = 'ProfileInventories'
    ITEM_INSTANCES = 'ItemInstances'
    ITEM_SOCKETS = 'ItemSockets'
    ITEM_COMMON_DATA = 'ItemCommonData'
    ITEM_PLUG_STATES = 'ItemPlugStates'
    ITEM_REUSABLE_PLUGS = 'ItemReusablePlugs'
  end
end

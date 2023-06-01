# frozen_string_literal: true

module Restiny
  module Platform
    ALL = -1
    XBOX = 1
    PSN = 2
    STEAM = 3
    EPIC = 6
  end

  module ComponentType
    CHARACTERS = "Characters"
    CHARACTER_EQUIPMENT = "CharacterEquipment"
    CHARACTER_INVENTORIES = "CharacterInventories"
    CHARACTER_LOADOUTS = "CharacterLoadouts"
    PROFILES = "Profiles"
    PROFILE_INVENTORIES = "ProfileInventories"
    ITEM_INSTANCES = "ItemInstances",
    ITEM_SOCKETS = "ItemSockets",
    ITEM_COMMON_DATA = "ItemCommonData",
    ITEM_PLUG_STATES = "ItemPlugStates",
    ITEM_REUSABLE_PLUGS = "ItemReusablePlugs"
  end

  module ItemLocation
    UNKNOWN = 0
    INVENTORY = 1
    VAULT = 2
    VENDOR = 3
    POSTMASTER = 4
  end

  module TierType
    UNKNOWN = 0
    CURRENCY = 1
    BASIC = 2
    COMMON = 3
    RARE = 4
    SUPERIOR = 5
    EXOTIC = 6
  end
end

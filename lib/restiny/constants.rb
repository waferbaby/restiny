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
    PROFILES = "Profiles"
    PROFILE_INVENTORIES = "ProfileInventories"
    CHARACTERS = "Characters"
    CHARACTER_INVENTORIES = "CharacterInventories"
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

COMPONENT_TYPE_PROFILES = "Profiles"
COMPONENT_TYPE_PROFILE_INVENTORIES = "ProfileInventories"
COMPONENT_TYPE_CHARACTERS = "Characters"
COMPONENT_TYPE_CHARACTER_INVENTORIES = "CharacterInventories"

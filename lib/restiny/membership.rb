# frozen_string_literal: true

module Restiny
  MEMBERSHIP_XBOX = 1
  MEMBERSHIP_PLAYSTATION = 2
  MEMBERSHIP_STEAM = 3

  class Membership
    attr_reader :id, :type, :cross_save_override, :icon_path, :is_public, :types

    def self.platform(type)
      case type
      when MEMBERSHIP_XBOX
        :xbox
      when MEMBERSHIP_PLAYSTATION
        :playstation
      when MEMBERSHIP_STEAM
        :steam
      end
    end

    def initialize(id:, type:, cross_save_override:, icon_path:, is_public:, types:)
      @id = id
      @type = type
      @cross_save_override = cross_save_override
      @icon_path = icon_path
      @is_public = is_public
      @types = types
    end
  end
end

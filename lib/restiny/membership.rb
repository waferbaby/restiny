# frozen_string_literal: true

module Restiny
  class Membership
    attr_reader :id, :type, :cross_save_override, :icon_path, :is_public, :types

    def self.platform(type)
      case type
      when PLATFORM_XBOX
        :xbox
      when PLATFORM_PSN
        :playstation
      when PLATFORM_STEAM
        :steam
      when PLATFORM_EPIC
        :epic
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

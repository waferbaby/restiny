# frozen_string_literal: true

require_relative 'base'

module Restiny
  module Api
    module Profile
      include Base

      def get_profile(membership_id:, membership_type:, components:, type_url: nil)
        if !components.is_a?(Array) || components.empty?
          raise Restiny::InvalidParamsError, 'Please provide at least one component'
        end

        url = "Destiny2/#{membership_type}/Profile/#{membership_id}/"
        url += type_url if type_url
        url += "?components=#{components.join(',')}"

        api_get(endpoint: url)
      end

      def get_character_profile(character_id:, membership_id:, membership_type:, components:)
        get_profile(
          membership_id: membership_id,
          membership_type: membership_type,
          components: components,
          type_url: "Character/#{character_id}/"
        )
      end

      def get_instanced_item_profile(item_id:, membership_id:, membership_type:, components:)
        get_profile(
          membership_id: membership_id,
          membership_type: membership_type,
          components: components,
          type_url: "Item/#{item_id}/"
        )
      end
    end
  end
end

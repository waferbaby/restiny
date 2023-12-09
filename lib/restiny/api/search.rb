# frozen_string_literal: true

require_relative 'base'

module Restiny
  module Api
    module Search
      include Base

      def search_player_by_bungie_name(name, membership_type: Platform::ALL)
        display_name, display_name_code = name.split('#')
        if display_name.nil? || display_name_code.nil?
          raise Restiny::InvalidParamsError, 'You must provide a valid Bungie name'
        end

        post("/Destiny2/SearchDestinyPlayerByBungieName/#{membership_type}/", params: {
               displayName: display_name, displayNameCode: display_name_code
             })
      end

      def search_users_by_global_name(name:, page: 0)
        post("/User/Search/GlobalName/#{page}/", params: { displayNamePrefix: name })
      end
    end
  end
end

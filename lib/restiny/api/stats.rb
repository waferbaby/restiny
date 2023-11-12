# frozen_string_literal: true

require_relative 'base'

module Restiny
  module Api
    module Stats
      include Base

      def get_post_game_carnage_report(activity_id:)
        raise Restiny::InvalidParamsError, 'Please provide an activity ID' if activity_id.nil?

        api_get(endpoint: "Destiny2/Stats/PostGameCarnageReport/#{activity_id}/")
      end 
      
      alias get_pgcr get_post_game_carnage_report
    end
  end
end

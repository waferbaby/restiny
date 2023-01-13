# frozen_string_literal: true

require 'faraday'
require 'faraday/follow_redirects'

module Restiny
  class Client
    API_BASE_URL = "https://www.bungie.net/Platform"

    attr_accessor :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    # Account methods

    def search_users(name, page = 0)
      response = post("/User/Search/GlobalName/#{page}", { displayNamePrefix: name })
      search_results = response.body&.dig('Response', 'searchResults')

      return [] if search_results.empty?

      search_results.map do |user|
        Restiny::User.new(
          display_name: user['bungieGlobalDisplayName'],
          display_name_code: user['bungieGlobalDisplayNameCode'],
          membership_id: user['bungieNetMembershipId'],
          memberships: user['destinyMemberships']
        )
      end
    end

    def get(endpoint_url, params = {})
      connection.get(API_BASE_URL + endpoint_url, params)
    end

    def post(endpoint_url, body, headers = {})
      connection.post(API_BASE_URL + endpoint_url, body, headers) 
    end

    private

    def default_headers
      {
        'User-Agent': "restiny v#{Restiny::VERSION}",
        'X-API-KEY': @api_key
      }
    end

    def connection
      @connection ||= Faraday.new(headers: default_headers) do |faraday|
        faraday.request :json
        faraday.request :url_encoded
        faraday.response :json
        faraday.response :follow_redirects
        faraday.response :raise_error
      end
    end
  end
end

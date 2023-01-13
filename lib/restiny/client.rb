# frozen_string_literal: true

require 'faraday'
require 'faraday/follow_redirects'

module Restiny
  class Client
    API_BASE_URL = "https://www.bungie.net/Platform/Destiny2"

    attr_accessor :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    # Account methods

    def search_players(name, platform = PLATFORM_ALL)
      get("/SearchDestinyPlayer/#{platform}/#{name}")
    end

    def get(endpoint_url, params = {})
      connection.get(API_BASE_URL + endpoint_url, params)
    end

    def post(endpoint_url, body, headers = {})
      connection.post(API_BASE_URL + endpoint_url, body, headers) 
    end

    private

    def connection
      @connection ||= Faraday.new(
        headers: {
          'Content-Type': 'application/json',
          'X-API-KEY': @api_key
        }
      ) do |faraday|
        faraday.request :json
        faraday.request :url_encoded
        faraday.response :json
        faraday.response :follow_redirects
        faraday.response :raise_error
      end
    end
  end
end

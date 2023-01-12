# frozen_string_literal: true

module Restiny
  class Client
    API_BASE_URL = "https://www.bungie.net/Platform/Destiny2/"

    attr_accessor :api_key

    def initializer(api_key)
      @api_key = api_key
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
      )
    end
  end
end

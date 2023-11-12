# frozen_string_literal: true

require 'restiny/constants'
require 'restiny/errors'
require 'faraday'
require 'faraday/follow_redirects'
require 'faraday/destiny/api'
require 'faraday/destiny/auth'

module Restiny
  BUNGIE_URL = 'https://www.bungie.net'
  API_BASE_URL = "#{BUNGIE_URL}/platform".freeze

  attr_accessor :api_key, :oauth_state, :oauth_client_id, :access_token, :user_agent

  module Api
    module Base
      def api_get(endpoint:, params: {})
        api_connection.get(endpoint, params, token_header).body
      end

      def api_post(endpoint:, params: {})
        api_connection.post(endpoint, params, token_header).body
      end

      private

      def check_oauth_client_id
        raise Restiny::RequestError, 'You need to set an OAuth client ID' unless @oauth_client_id
      end

      def default_headers
        { 'User-Agent': @user_agent || "restiny v#{Restiny::VERSION}" }
      end

      def api_connection
        raise Restiny::InvalidParamsError, 'You need to set an API key' unless @api_key

        @api_connection ||=
          Faraday.new(
            url: API_BASE_URL,
            headers: default_headers.merge('X-API-KEY': @api_key)
          ) do |faraday|
            faraday.request :json
            faraday.response :follow_redirects
            faraday.response :destiny_api
            faraday.response :json
          end
      end

      def auth_connection
        @auth_connection ||=
          Faraday.new(url: API_BASE_URL, headers: default_headers) do |faraday|
            faraday.request :url_encoded
            faraday.response :follow_redirects
            faraday.response :destiny_auth
            faraday.response :json
          end
      end

      def token_header
        {}.tap { |headers| headers['authorization'] = "Bearer #{@access_token}" if @access_token }
      end
    end
  end
end

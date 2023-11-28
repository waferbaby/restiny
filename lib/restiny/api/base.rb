# frozen_string_literal: true

require 'restiny/constants'
require 'restiny/errors'
require 'httpx'
require 'json'

module Restiny
  BUNGIE_URL = 'https://www.bungie.net'
  API_BASE_URL = "#{BUNGIE_URL}/platform".freeze

  attr_accessor :api_key, :oauth_state, :oauth_client_id, :access_token, :user_agent

  module Api
    module Base
      def get(endpoint:)
        make_api_request(endpoint: endpoint, method: :get)
      end

      def post(endpoint:, params: {})
        make_api_request(endpoint: endpoint, method: :post, params: params)
      end

      private

      def http_client
        HTTPX.with(headers: api_headers).plugin(:follow_redirects, follow_insecure_redirects: true)
      end

      def make_api_request(endpoint:, method: :get, params: {})
        raise Restiny::InvalidParamsError, 'You need to set an API key (Restiny.api_key)' if @api_key.nil?

        response = http_client.request(method, API_BASE_URL + endpoint, json: params)
        response.raise_for_status

        response.json['Response']
      rescue HTTPX::Error => e
        handle_api_error(e)
      end

      def handle_api_error(error)
        klass = case error.response.status
                when 400..499 then ::Restiny::RequestError
                when 500..599 then ::Restiny::ResponseError
                else ::Restiny::Error
                end

        body = error.response.json
        raise klass, "#{body['ErrorStatus']} (#{body['ErrorCode']}): #{body['Message']}"
      rescue HTTPX::Error
        raise klass, error.response.status.to_s if error.response
      end

      def api_headers
        {}.tap do |headers|
          headers['x-api-key'] = @api_key
          headers['user-agent'] = @user_agent || "restiny v#{Restiny::VERSION}"
          headers['authentication'] = "Bearer #{@access_token}" unless @access_token.nil?
        end
      end
    end
  end
end

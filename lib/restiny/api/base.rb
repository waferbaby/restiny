# frozen_string_literal: true

require 'restiny/constants'
require 'restiny/errors'
require 'httpx'
require 'json'

module Restiny
  BUNGIE_URL = 'https://www.bungie.net'

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
        HTTPX.with(origin: BUNGIE_URL, headers: api_headers).plugin(:follow_redirects, follow_insecure_redirects: true)
      end

      def make_api_request(endpoint:, method: :get, params: {})
        raise Restiny::InvalidParamsError, 'You need to set an API key (Restiny.api_key)' if @api_key.nil?

        response = http_client.with(base_path: '/platform/').request(method, endpoint, json: params)
        response.raise_for_status

        response.json['Response']
      rescue HTTPX::TimeoutError, HTTPX::ResolveError => e
        raise Restiny::RequestError, e.message
      rescue HTTPX::HTTPError => e
        handle_api_error(e)
      end

      def handle_api_error(error)
        klass = case error.response.status
                when 400..499 then ::Restiny::RequestError
                when 500..599 then ::Restiny::ResponseError
                else ::Restiny::Error
                end

        raise klass, if error.response.headers['content-type'].match?(%r{^application/json})
                       error_message_from_json(error.response.json)
                     else
                       error.status
                     end
      end

      def error_message_from_json(json)
        "#{json['ErrorStatus']} (#{json['ErrorCode']}): #{json['Message']}"
      end

      def api_headers
        {}.tap do |headers|
          headers['x-api-key'] = @api_key
          headers['user-agent'] = @user_agent || "restiny v#{Restiny::VERSION}"
          headers['authentication'] = "Bearer #{@access_token}" unless @access_token.nil?
        end
      end

      def valid_array_param?(param)
        param.is_a?(Array) && !param.empty?
      end
    end
  end
end

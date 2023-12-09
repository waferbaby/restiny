# frozen_string_literal: true

require_relative 'base'

require 'securerandom'

module Restiny
  module Api
    module Authentication
      include Base

      CODE_RESPONSE_TYPE = 'code'
      AUTH_CODE_GRANT_TYPE = 'authorization_code'

      def get_authorise_url(redirect_url: nil, state: nil)
        check_oauth_client_id

        params = {
          response_type: CODE_RESPONSE_TYPE,
          client_id: @oauth_client_id,
          state: state || SecureRandom.hex(15)
        }

        params['redirect_url'] = redirect_url unless redirect_url.nil?

        query = params.map { |k, v| "#{k}=#{v}" }.join('&')

        "#{BUNGIE_URL}/en/oauth/authorize/?#{query}"
      end

      def request_access_token(code, redirect_url: nil)
        check_oauth_client_id

        params = { code: code, grant_type: AUTH_CODE_GRANT_TYPE, client_id: @oauth_client_id }
        params['redirect_url'] = redirect_url unless redirect_url.nil?

        response = http_client.post('/platform/app/oauth/token/', form: params)
        response.raise_for_status

        response.json
      rescue HTTPX::Error => e
        handle_authentication_error(e)
      end

      private

      def handle_authentication_error(error)
        raise Restiny::AuthenticationError,
              "#{error.response.json['error_description']} (#{error.response.json['error']})"
      rescue HTTPX::Error
        raise Restiny::AuthenticationError,
              "#{error.response.status}: #{error.response.headers['x-selfurl']}"
      end

      def check_oauth_client_id
        return if @oauth_client_id

        raise Restiny::RequestError,
              'You need to set an OAuth client ID (Restiny.oauth_client_id)'
      end
    end
  end
end

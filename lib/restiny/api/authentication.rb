# frozen_string_literal: true

require_relative 'base'

require 'securerandom'

module Restiny
  module Api
    module Authentication
      include Base

      def get_authorise_url(redirect_url: nil, state: nil)
        check_oauth_client_id

        @oauth_state = state || SecureRandom.hex(15)

        params = { response_type: 'code', client_id: @oauth_client_id, state: @oauth_state }
        params['redirect_url'] = redirect_url unless redirect_url.nil?

        auth_connection.build_url("#{BUNGIE_URL}/en/oauth/authorize/", params).to_s
      end

      def request_access_token(code:, redirect_url: nil)
        check_oauth_client_id

        params = { code: code, grant_type: 'authorization_code', client_id: @oauth_client_id }
        params['redirect_url'] = redirect_url unless redirect_url.nil?

        auth_connection.post('app/oauth/token/', params).body
      end
    end
  end
end

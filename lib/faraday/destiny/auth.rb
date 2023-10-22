# frozen_string_literal: true

require 'faraday'
require 'restiny/errors'

module Faraday
  module Restiny
    Faraday::Response.register_middleware(destiny_auth: 'Faraday::Restiny::Auth')

    class Auth < Middleware
      def on_complete(env)
        return if env['response_body'].empty? || env['url'].to_s !~ /oauth/

        return unless env['response_body']['error']

        raise ::Restiny::AuthenticationError.new(
          env['response_body']['error_description'],
          env['response_body']['error']
        )
      end
    end
  end
end

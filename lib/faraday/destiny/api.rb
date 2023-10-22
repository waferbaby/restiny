# frozen_string_literal: true

require 'faraday'
require 'restiny/errors'

module Faraday
  module Restiny
    Faraday::Response.register_middleware(destiny_api: 'Faraday::Restiny::Api')

    class Api < Middleware
      def on_complete(env)
        return if env['response_body'].empty? || !env['response_body']['ErrorCode']

        if env['response_body']['ErrorCode'] == 1
          env[:body] = env['response_body']['Response']
          return
        end

        klass =
          case env['status']
          when 400..499
            ::Restiny::RequestError
          when 500..599
            ::Restiny::ResponseError
          else
            ::Restiny::Error
          end

        raise klass.new(env['response_body']['Message'], env['response_body']['ErrorStatus'])
      end
    end
  end
end

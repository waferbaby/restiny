require "faraday"
require "restiny/errors"

module Faraday
  module Restiny
    Faraday::Response.register_middleware(destiny_api: "Faraday::Restiny::Api")

    class Api < Middleware
      def on_complete(env)
        payload = JSON.parse(env["response_body"])
        if payload["ErrorCode"] == 1
          env["response_body"] = payload.dig("Response")
          return
        end

        klass =
          case env["status"]
          when 400..499
            ::Restiny::RequestError
          when 500..599
            ::Restiny::ResponseError
          else
            ::Restiny::Error
          end

        raise klass.new(payload["Message"], payload["ErrorStatus"])
      rescue JSON::ParserError
        raise ::Restiny.ResponseError.new("Unable to parse API response")
      end
    end
  end
end

# frozen_string_literal: true

module Restiny
  class Error < StandardError; end
  class NetworkError < Error; end
  class RequestError < Error; end
  class InvalidParamsError < RequestError; end
  class RateLimitedError < RequestError; end
  class AuthenticationError < RequestError; end
  class ResponseError < Error; end
end

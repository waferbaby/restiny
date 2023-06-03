# frozen_string_literal: true

module Restiny
  class Error < StandardError
    def initialize(message, details = nil)
      @details = details
      super(message)
    end
  end

  class RequestError < Error
  end

  class InvalidParamsError < RequestError
  end

  class RateLimitedError < RequestError
  end

  class ResponseError < Error
  end

  class AuthenticationError < ResponseError
  end
end

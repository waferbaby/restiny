# frozen_string_literal: true

module Restiny
  class Error < StandardError
    def initialize(message, status = nil)
      @status = status
      super(message)
    end
  end

  class RequestError < Error
  end

  class InvalidParamsError < RequestError
  end

  class RateLimitedError < RequestError
  end

  class AuthenticationError < RequestError
  end

  class ResponseError < Error
  end
end

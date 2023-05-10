# frozen_string_literal: true

module Restiny
  class Error < StandardError; end
  class RequestError < Error; end
    class InvalidParamsError < RequestError; end
    class RateLimitedError < RequestError
    end

  class ResponseError < Error; end
  class NetworkError < Error
    attr_accessor :status_code

    def initialize(message, status_code = nil)
      @status_code = status_code
      super(message)
    end
  end
end

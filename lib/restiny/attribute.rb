# frozen_string_literal: true

module Restiny
  class Attribute < Hash
    def self.snake_case(key)
      key.to_s.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    end

    def initialize(data = {})
      super
      data.each { |k, v| self[k] = v } if data.is_a?(Hash)
    end

    def []=(key, value)
      super(self.class.snake_case(key), prepare(value))
    end

    private

    def prepare(data)
      case data
      when Hash
        Restiny::Attribute.new(data)
      when Array
        data.map { |item| item.is_a?(Hash) ? Restiny::Attribute.new(item) : item }
      else
        data
      end
    end

    def method_missing(method_name, *_args)
      method_name = method_name.to_s
      return self[method_name] if include?(method_name)

      super
    end

    def respond_to_missing?(method_name, include_private)
      include?(method_name.to_s) || super
    end
  end
end

# frozen_string_literal: true

require 'restiny/attribute'

module Restiny
  class Entry
    attr_accessor :display_properties, :hash, :index, :redacted, :blacklisted

    def initialize(data = {})
      return unless data.is_a?(Hash)

      data.each do |key, value|
        method = "#{Restiny::Attribute.snake_case(key)}=".to_sym
        send(method.to_sym, Restiny::Attribute.new(value)) if respond_to?(method)
      end
    end
  end
end

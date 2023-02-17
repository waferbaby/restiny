# frozen_string/literal: true

module Restiny
  class ManifestItem
    attr_reader :id, :name, :description, :has_icon, :is_redacted

    def initialize(id:, name:, description:, has_icon:, is_redacted:)
      @id = id
      @name = name
      @description = description
      @has_icon = has_icon
      @is_redacted = is_redacted
    end
  end
end

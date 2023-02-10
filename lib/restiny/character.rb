# frozen_string_literal: true

module Restiny
  class Character
    attr_accessor :id, :playtime, :light_level, :stats, :emblem, :progression

    def initialize(id:, session_playtime:, total_playtime:, light_level:, stats:, emblem:, progression:)
      @id = id
      @playtime = { session: session_playtime, total: total_playtime }
      @light_level = light_level
      @stats = stats
      @emblem = emblem
      @progression = progression
    end
  end
end


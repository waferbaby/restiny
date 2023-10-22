# frozen_string_literal: true

require 'sqlite3'

module Restiny
  class Manifest
    ENTITIES = {
      Achievement: %w[achievement achievements],
      Activity: %w[activity activities],
      ActivityGraph: %w[activity_graph activity_graphs],
      ActivityMode: %w[activity_mode activity_modes],
      ActivityModifier: %w[activity_modifier activity_modifiers],
      ActivityType: %w[activity_type activity_types],
      Artifact: %w[artifact artifacts],
      Bond: %w[bonds bonds],
      BreakerType: %w[breaker_type breaker_types],
      Checklist: %w[checklist checklists],
      Class: %w[guardian_class guardian_classes],
      Collectible: %w[collectible collectibles],
      DamageType: %w[damage_type damage_types],
      Destination: %w[destination destinations],
      EnergyType: %w[energy_type energy_types],
      EquipmentSlot: %w[equipment_slot equipment_slots],
      EventCard: %w[event_card event_cards],
      Faction: %w[faction factions],
      Gender: %w[guardian_gender guardian_genders],
      GuardianRank: %w[guardian_rank guardian_ranks],
      GuardianRankConstants: %w[guardian_rank_constant guardian_rank_constants],
      HistoricalStats: %w[historical_stat historical_stats],
      InventoryBucket: %w[inventory_bucket inventory_buckets],
      InventoryItem: %w[inventory_item inventory_items],
      ItemCategory: %w[item_category item_categories],
      ItemTierType: %w[item_tier_type item_tier_types],
      LoadoutColor: %w[loadout_color loadout_colors],
      LoadoutConstants: %w[loadout_constant loadout_constants],
      LoadoutIcon: %w[loadout_icon loadout_icons],
      LoadoutName: %w[loadout_name loadout_names],
      Location: %w[location locations],
      Lore: %w[lore_entry lore_entries],
      MaterialRequirementSet: %w[material_requirement_set material_requirement_sets],
      MedalTier: %w[medal_tier medal_tiers],
      Metric: %w[metric metrics],
      Milestone: %w[milestone milestones],
      Objective: %w[objective objectives],
      Place: %w[place places],
      PlugSet: %w[plug_set plug_sets],
      PowerCap: %w[power_cap power_caps],
      PresentationNode: %w[presentation_node presentation_nodes],
      Progression: %w[progression progressions],
      ProgressionLevelRequirement: %w[progression_level_requirement progression_level_requirements],
      Race: %w[guardian_race guardian_races],
      Record: %w[record records],
      ReportReasonCategory: %w[report_reason_category report_reason_categories],
      RewardSource: %w[reward_source reward_sources],
      SackRewardItemList: %w[sack_reward_item_list sack_reward_item_lists],
      SandboxPattern: %w[sandbox_pattern sandbox_patterns],
      SandboxPerk: %w[sandbox_perk sandbox_perks],
      Season: %w[season seasons],
      SeasonPass: %w[season_pass season_passes],
      SocialCommendation: %w[commendation commendations],
      SocialCommendationNode: %w[commendation_node commendation_nodes],
      SocketCategory: %w[socket_category socket_categories],
      SocketType: %w[socket_type socket_types],
      Stat: %w[stat stats],
      StatGroup: %w[stat_group stat_groups],
      TalentGrid: %w[talent_grid talent_grids],
      Trait: %w[trait traits],
      Unlock: %w[unlock unlocks],
      Vendor: %w[vendor vendors],
      VendorGroup: %w[vendor_group vendor_groups]
    }.freeze

    attr_reader :file_path, :version

    ENTITIES.each do |entity, method_names|
      full_table_name = "Destiny#{entity}Definition"
      single_method_name, plural_method_name = method_names

      define_method single_method_name do |id|
        fetch_item(table_name: full_table_name, id:)
      end

      define_method plural_method_name do |limit: nil|
        fetch_items(table_name: full_table_name, limit:)
      end
    end

    def initialize(file_path, version)
      if file_path.empty? || !File.exist?(file_path) || !File.file?(file_path)
        raise Restiny::InvalidParamsError, 'You must provide a valid path for the manifest file'
      end

      @database = SQLite3::Database.new(file_path, results_as_hash: true)
      @file_path = file_path
      @version = version
    end

    private

    def get_entity_names
      query = "SELECT name from sqlite_schema WHERE name LIKE 'Destiny%'"
      @database.execute(query).map { |row| row['name'].gsub(/(Destiny|Definition)/, '') }
    end

    def fetch_item(table_name:, id:)
      query = "SELECT json FROM #{table_name} WHERE json_extract(json, '$.hash')=?"
      result = @database.execute(query, id)

      return nil if result.nil? || result.count < 1 || !result[0].include?('json')

      JSON.parse(result[0]['json'])
    rescue SQLite3::Exception => e
      raise Restiny::RequestError, "Error while fetching item (#{e})"
    end

    def fetch_items(table_name:, limit: nil)
      bindings = []

      query = "SELECT json FROM #{table_name} ORDER BY json_extract(json, '$.index')"

      if limit
        query << ' LIMIT ?'
        bindings << limit
      end

      items = []

      @database.execute(query, bindings) do |row|
        item = JSON.parse(row['json'])
        yield item if block_given?

        items << item
      end

      items unless block_given?
    rescue SQLite3::Exception => e
      raise Restiny::RequestError, "Error while fetching items (#{e})"
    end
  end
end

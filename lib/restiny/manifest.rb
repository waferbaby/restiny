# frozen_string/literal: true
require "down"
require "json"
require "sqlite3"
require "zip"

module Restiny
  class Manifest
    TABLES = {
      Achievement: {item: "achievement", items: "achievements"},
      Activity: {item: "activity", items: "activities"},
      ActivityGraph: {item: "activity_graph", items: "activity_graphs"},
      ActivityMode: {item: "activity_mode", items: "activity_modes"},
      ActivityModifier: {item: "activity_modifier", items: "activity_modifiers"},
      ActivityType: {item: "activity_type", items: "activity_types"},
      Artifact: {item: "artifact", items: "artifacts"},
      Bond: {item: "bond", items: "bonds"},
      BreakerType: {item: "breaker_type", items: "breaker_types"},
      Checklist: {item: "checklist", items: "checklists"},
      Class: {item: "guardian_class", items: "guardian_classes"},
      Collectible: {item: "collectible", items: "collectibles"},
      DamageType: {item: "damage_type", items: "damage_types"},
      Destination: {item: "destination", items: "destinations"},
      EnergyType: {item: "energy_type", items: "energy_types"},
      EquipmentSlot: {item: "equipment_slot", items: "equipment_slots"},
      EventCard: {item: "event_card", items: "event_cards"},
      Faction: {item: "faction", items: "factions"},
      Gender: {item: "gender", items: "genders"},
      HistoricalStats: {item: "historical_stat", items: "historical_stats"},
      InventoryBucket: {item: "inventory_bucket", items: "inventory_buckets"},
      InventoryItem: {item: "inventory_item", items: "inventory_items"},
      ItemCategory: {item: "item_category", items: "item_categories"},
      ItemTierType: {item: "item_tier_type", items: "item_tier_types"},
      Location: {item: "location", items: "locations"},
      Lore: {item: "lore", items: "lore_entries"},
      MaterialRequirementSet: {item: "material_requirement_set", items: "material_requirement_sets"},
      MedalTier: {item: "medal_tier", items: "medal_tiers"},
      Metric: {item: "metric", items: "metrics"},
      Milestone: {item: "milestone", items: "milestones"},
      Objective: {item: "objective", items: "objectives"},
      Place: {item: "place", items: "places"},
      PlugSet: {item: "plug_set", items: "plug_sets"},
      PowerCap: {item: "power_cap", items: "power_caps"},
      PresentationNode: {item: "presentation_node", items: "presentation_nodes"},
      Progression: {item: "progression", items: "progression_data"},
      ProgressionLevelRequirement: {item: "progression_level_requirement", items: "progression_level_requirements"},
      Race: {item: "race", items: "races"},
      Record: {item: "record", items: "records"},
      ReportReasonCategory: {item: "report_reason_category", items: "report_reason_categories"},
      RewardSource: {item: "reward_source", items: "reward_sources"},
      SackRewardItemList: {item: "sack_reward_item_list", items: "sack_reward_item_lists"},
      SandboxPattern: {item: "sandbox_pattern", items: "sandbox_patterns"},
      SandboxPerk: {item: "sandbox_perk", items: "sandbox_perks"},
      Season: {item: "season", items: "seasons"},
      SeasonPass: {item: "season_pass", items: "season_passes"},
      SocketCategory: {item: "socket_category", items: "socket_categories"},
      SocketType: {item: "socket_type", items: "socket_types"},
      Stat: {item: "stat", items: "stats"},
      StatGroup: {item: "stat_group", items: "stat_groups"},
      TalentGrid: {item: "talent_grid", items: "talent_grids"},
      Trait: {item: "trait", items: "traits"},
      Unlock: {item: "unlock", items: "unlocks"},
      Vendor: {item: "vendor", items: "vendors"},
      VendorGroup: {item: "vendor_group", items: "vendor_groups"}
    }

    attr_reader :file_path

    TABLES.each do |table_name, method_names|
      full_table_name = "Destiny#{table_name}Definition"

      define_method method_names[:item] do |hash|
        fetch_item(full_table_name, hash)
      end

      define_method method_names[:items] do |options = {}|
        fetch_items(full_table_name, options)
      end
    end

    def self.download(url)
      zipped_file = Down.download(url)
      manifest_path = zipped_file.path + ".db"

      Zip::File.open(zipped_file) { |file| file.first.extract(manifest_path) }

      new(manifest_path)
    rescue Down::ResponseError => error
      raise Restiny::NetworkError.new("Unable to download the manifest file", error.response.code)
    rescue Zip::Error => error
      raise Restiny::Error.new("Unable to unzip the manifest file (#{error})")
    end

    def initialize(file_path)
      if file_path.empty? || !File.exist?(file_path) || !File.file?(file_path)
        raise Restiny::InvalidParamsError.new("You must provide a valid path for the manifest file")
      end

      @database = SQLite3::Database.new(file_path, results_as_hash: true)
      @file_path = file_path
    end

    private

    def fetch_item(table_name, hash)
      query = "SELECT json FROM #{table_name} WHERE json_extract(json, '$.hash')=?"
      result = @database.execute(query, hash)

      return nil if result.nil? || result.count < 1 || !result[0].include?("json")

      JSON.parse(result[0]["json"])
    rescue SQLite3::Exception => e
      raise Restiny::RequestError.new("Error while fetching item (#{e})")
    end

    def fetch_items(table_name, options = {})
      bindings = []

      query = "SELECT json FROM #{table_name} "
      query << "WHERE json_extract(json, '$.displayProperties.name') != '' " if options[:filter_empty]
      query << "ORDER BY json_extract(json, '$.index')"

      if options[:limit]
        query << " LIMIT ?"
        bindings << options[:limit]
      end

      result = []

      @database.execute(query, bindings) do |row|
        item = JSON.parse(row["json"])

        if block_given?
          yield item
        else
          result << item
        end
      end

      result unless block_given?
    rescue SQLite3::Exception => e
      raise Restiny::RequestError.new("Error while fetching item (#{e})")
    end
  end
end

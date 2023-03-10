# frozen_string/literal: true

require 'down'
require 'json'
require 'sqlite3'
require 'zip'

module Restiny
  class Manifest
    TABLES = {
      'DestinyAchievementDefinition': { item: 'achievement', items: 'achievements' },
      'DestinyActivityDefinition': { item: 'activity', items: 'activities' },
      'DestinyActivityGraphDefinition': { item: 'activity_graph', items: 'activity_graphs' },
      'DestinyActivityModeDefinition': { item: 'activity_modes', items: 'activity_modes' },
      'DestinyActivityModifierDefinition': { item: 'activity_modifier', items: 'activity_modifiers' },
      'DestinyActivityTypeDefinition': { item: 'activity_type', items: 'activity_types' },
      'DestinyArtifactDefinition': { item: 'artifact', items: 'artifacts' },
      'DestinyBondDefinition': { item: 'bond', items: 'bonds' },
      'DestinyBreakerTypeDefinition': { item: 'breaker_type', items: 'breaker_types' },
      'DestinyChecklistDefinition': { item: 'checklist', items: 'checklists' },
      'DestinyClassDefinition': { item: 'class', items: 'classes' },
      'DestinyCollectibleDefinition': { item: 'collectible', items: 'collectibles' },
      'DestinyDamageTypeDefinition': { item: 'damage_type', items: 'damage_types' },
      'DestinyDestinationDefinition': { item: 'destination', items: 'destinations' },
      'DestinyEnergyTypeDefinition': { item: 'energy_type', items: 'energy_types' },
      'DestinyEquipmentSlotDefinition': { item: 'eqiupment_slot', items: 'equipment_slots' },
      'DestinyEventCardDefinition': { item: 'event_card', items: 'event_cards' },
      'DestinyFactionDefinition': { item: 'faction', items: 'factions' },
      'DestinyGenderDefinition': { item: 'gender', items: 'genders' },
      'DestinyHistoricalStatsDefinition': { item: 'historical_stat', items: 'historical_stats' },
      'DestinyInventoryBucketDefinition': { item: 'inventory_bucket', items: 'inventory_buckets' },
      'DestinyInventoryItemDefinition': { item: 'inventory_item', items: 'inventory_items' },
      'DestinyItemCategoryDefinition': { item: 'item_category', items: 'item_categories' },
      'DestinyItemTierTypeDefinition': { item: 'item_tier_type', items: 'item_tier_types' },
      'DestinyLocationDefinition': { item: 'location', items: 'locations' },
      'DestinyLoreDefinition': { item: 'lore', items: 'lore_entries' },
      'DestinyMaterialRequirementSetDefinition': { item: 'material_requirement_set', items: 'material_requirement_sets' },
      'DestinyMedalTierDefinition': { item: 'medal_tier', items: 'medal_tiers' },
      'DestinyMetricDefinition': { item: 'metric', items: 'metrics' },
      'DestinyMilestoneDefinition': { item: 'milestone', items: 'milestones' },
      'DestinyObjectiveDefinition': { item: 'objective', items: 'objectives' },
      'DestinyPlaceDefinition': { item: 'place', items: 'places' },
      'DestinyPlugSetDefinition': { item: 'plug_set', items: 'plug_sets' },
      'DestinyPowerCapDefinition': { item: 'power_cap', items: 'power_caps' },
      'DestinyPresentationNodeDefinition': { item: 'presentation_node', items: 'presentation_nodes' },
      'DestinyProgressionDefinition': { item: 'progression', items: 'progression_data' },
      'DestinyProgressionLevelRequirementDefinition': { item: 'progression_level_requirement', items: 'progression_level_requirements' },
      'DestinyRaceDefinition': { item: 'race', items: 'races' },
      'DestinyRecordDefinition': { item: 'record', items: 'records' },
      'DestinyReportReasonCategoryDefinition': { item: 'report_reason_category', items: 'report_reason_categories' },
      'DestinyRewardSourceDefinition': { item: 'reward_source', items: 'reward_sources' },
      'DestinySackRewardItemListDefinition': { item: 'sack_reward_item_list', items: 'sack_reward_item_lists' },
      'DestinySandboxPatternDefinition': { item: 'sandbox_pattern', items: 'sandbox_patterns' },
      'DestinySandboxPerkDefinition': { item: 'sandbox_perk', items: 'sandbox_perks' },
      'DestinySeasonDefinition': { item: 'season', items: 'seasons' },
      'DestinySeasonPassDefinition': { item: 'season_pass', items: 'season_passes' },
      'DestinySocketCategoryDefinition': { item: 'socket_category', items: 'socket_categories' },
      'DestinySocketTypeDefinition': { item: 'socket_type', items: 'socket_types' },
      'DestinyStatDefinition': { item: 'stat', items: 'stats' },
      'DestinyStatGroupDefinition': { item: 'stat_group', items: 'stat_groups' },
      'DestinyTalentGridDefinition': { item: 'talent_grid', items: 'talent_grids' },
      'DestinyTraitCategoryDefinition': { item: 'trait_category', items: 'trait_categories' },
      'DestinyTraitDefinition': { item: 'trait', items: 'traits' },
      'DestinyUnlockDefinition': { item: 'unlock', items: 'unlocks' },
      'DestinyVendorDefinition': { item: 'vendor', items: 'vendors' },
      'DestinyVendorGroupDefinition': { item: 'vendor_group', items: 'vendor_groups' }
    }

    attr_reader :file_path

    TABLES.each do |table_name, method_names|
      define_method method_names[:item] do |id|
        query_table(table_name, id: id)[0]
      end

      define_method method_names[:items] do |limit: nil|
        query_table(table_name, limit: limit)
      end
    end

    def self.download(url)
      zipped_file = Down.download(url)
      manifest_path = zipped_file.path + ".db" 

      Zip::File.open(zipped_file) { |file| file.first.extract(manifest_path) }

      self.new(manifest_path)
    rescue Down::Error
      raise "Unable to download the manifest from Bungie"
    rescue Zip::Error
      raise "Unable to unzip the manifest file"
    end

    def initialize(file_path)
      raise "You must provide the file path for the manifest file" if file_path.empty?

      @database = SQLite3::Database.new(file_path, results_as_hash: true)
      @file_path = file_path
    end

    private

    def self.clean_row_keys(row_hash)
      OpenStruct.new.tap do |output|
        row_hash.each_pair do |key, value|
          key = key.gsub(/(\B[A-Z])/, '_\1') if key =~ /\B[A-Z]/
          output[key.downcase] = if value.is_a?(Hash)
                                   clean_row_keys(value)
                                 elsif value.is_a?(Array)
                                   value.map { |item| item.is_a?(Hash) ? clean_row_keys(item) : value }
                                 else
                                   value
                                 end
        end
      end
    end

    def query_table(table_name, id: nil, limit: nil)
      query = "SELECT json FROM #{table_name}"
      bindings = []

      if id
        query << " WHERE id=?"
        bindings << id
      end

      query << " ORDER BY json_extract(json, '$.index')" unless id

      if limit
        query << " LIMIT ?"
        bindings << limit
      end

      @database.execute(query, bindings).map do |row|
        Manifest::clean_row_keys(JSON.parse(row['json'])) unless row['json'].nil?
      end
    rescue SQLite3::Exception => e
      raise "Error while querying the manifest (#{e})"
    end
  end
end

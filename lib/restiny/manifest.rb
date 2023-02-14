# frozen_string/literal: true

require 'down'
require 'sqlite3'
require 'zip'

module Restiny
  class Manifest
    TABLES = {
      'DestinyAchievementDefinition': 'achievements',
      'DestinyActivityDefinition': 'activities',
      'DestinyActivityGraphDefinition': 'activity_graphs',
      'DestinyActivityModeDefinition': 'activity_modes',
      'DestinyActivityModifierDefinition': 'activity_modifiers',
      'DestinyActivityTypeDefinition': 'activity_types',
      'DestinyArtifactDefinition': 'artifacts',
      'DestinyBondDefinition': 'bonds',
      'DestinyBreakerTypeDefinition': 'breaker_types',
      'DestinyChecklistDefinition': 'checklists',
      'DestinyClassDefinition': 'classes',
      'DestinyCollectibleDefinition': 'collectibles',
      'DestinyDamageTypeDefinition': 'damage_types',
      'DestinyDestinationDefinition': 'destinations',
      'DestinyEnergyTypeDefinition': 'energy_types',
      'DestinyEquipmentSlotDefinition': 'equipment_slots',
      'DestinyEventCardDefinition': 'event_cards',
      'DestinyFactionDefinition': 'factions',
      'DestinyGenderDefinition': 'genders',
      'DestinyHistoricalStatsDefinition': 'historical_stats',
      'DestinyInventoryBucketDefinition': 'inventory_buckets',
      'DestinyInventoryItemDefinition': 'inventory_items',
      'DestinyItemCategoryDefinition': 'item_categories',
      'DestinyItemTierTypeDefinition': 'item_tier_types',
      'DestinyLocationDefinition': 'locations',
      'DestinyLoreDefinition': 'lore',
      'DestinyMaterialRequirementSetDefinition': 'material_requirement_sets',
      'DestinyMedalTierDefinition': 'medal_tiers',
      'DestinyMetricDefinition': 'metrics',
      'DestinyMilestoneDefinition': 'milestones',
      'DestinyObjectiveDefinition': 'objectives',
      'DestinyPlaceDefinition': 'places',
      'DestinyPlugSetDefinition': 'plug_sets',
      'DestinyPowerCapDefinition': 'power_caps',
      'DestinyPresentationNodeDefinition': 'presentation_nodes',
      'DestinyProgressionDefinition': 'progression',
      'DestinyProgressionLevelRequirementDefinition': 'progression_level_requirements',
      'DestinyRaceDefinition': 'races',
      'DestinyRecordDefinition': 'records',
      'DestinyReportReasonCategoryDefinition': 'report_reason_categories',
      'DestinyRewardSourceDefinition': 'reward_sources',
      'DestinySackRewardItemListDefinition': 'sack_reward_item_lists',
      'DestinySandboxPatternDefinition': 'sandbox_patterns',
      'DestinySandboxPerkDefinition': 'sandbox_perks',
      'DestinySeasonDefinition': 'seasons',
      'DestinySeasonPassDefinition': 'season_passes',
      'DestinySocketCategoryDefinition': 'socket_categories',
      'DestinySocketTypeDefinition': 'socket_types',
      'DestinyStatDefinition': 'stats',
      'DestinyStatGroupDefinition': 'stat_groups',
      'DestinyTalentGridDefinition': 'talent_grids',
      'DestinyTraitCategoryDefinition': 'trait_categories',
      'DestinyTraitDefinition': 'traits',
      'DestinyUnlockDefinition': 'unlocks',
      'DestinyVendorDefinition': 'vendors',
      'DestinyVendorGroupDefinition': 'vendor_groups'
    }

    def self.download(url)
      zipped_file = Down.download(url)
      manifest_path = zipped_file.path + ".db" 

      Zip::File.open(zipped_file) { |file| file.first.extract(manifest_path) }

      self.new(manifest_path)
    rescue Down::Error
      raise "Unable to download the manifest from Bungie"
    end

      TABLES.each do |table_name, method_name|
        define_method method_name do |order_by: 'index', where: nil, limit: nil|
          query_table(table_name, where: where, order_by: order_by, limit: limit)
        end
      end

    def initialize(file_path)
      @database = SQLite3::Database.new(file_path)
    end

    private

    def query_table(table_name, where:, order_by:, limit:)
      query = "SELECT * FROM #{table_name}"
      bindings = []

      if where
        query << " WHERE ?"
        bindings << where
      end

      if order_by
        query << " ORDER BY ?"
        bindings << order_by
      end

      if limit
        query << " LIMIT ?"
        bindings << limit
      end

      @database.execute(query, bindings)
    end
  end
end

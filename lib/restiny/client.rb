# frozen_string_literal: true

require 'faraday'
require 'faraday/follow_redirects'

module Restiny
  class Client
    BUNGIE_URL = "https://www.bungie.net"
    API_BASE_URL = BUNGIE_URL + "/Platform"

    attr_accessor :api_key, :manifest

    def initialize(api_key)
      @api_key = api_key
    end

    # Manifest methods

    def download_manifest(locale = 'en')
      response = get("/Destiny2/Manifest/")

      manifest_path = response.body.dig('Response', 'mobileWorldContentPaths', locale)
      raise "Unable to determine manifest URL" if manifest_path.nil?

      Manifest.download(BUNGIE_URL + manifest_path)
    end

    # Profile methods

    def get_profile(membership_id, membership_type, components = [])
      raise "You must provide at least one component" if components.empty?

      component_query = components.join(",")
      response = get("/Destiny2/#{membership_type}/Profile/#{membership_id}?components=#{component_query}")

      {}.tap do |output|
        components.each do |component|
          case component.downcase
          when 'characters'
            output[:characters] = parse_profile_characters_response(response)
          end
        end
      end
    end

    # Account methods

    def get_user_by_bungie_name(full_display_name, membership_type = PLATFORM_ALL)
      display_name, display_name_code = full_display_name.split('#')
      raise "You must provide a valid Bungie name" if display_name.nil? || display_name_code.nil?

      params = {
        displayName: display_name,
        displayNameCode: display_name_code
      }

      response = post("/Destiny2/SearchDestinyPlayerByBungieName/#{membership_type}/", params)
      result = response.body.dig('Response')

      return [] if result.nil?

      Restiny::User.new(
        display_name: result[0]['bungieGlobalDisplayName'],
        display_name_code: result[0]['bungieGlobalDisplayNameCode'],
        memberships: result
      )
    end

    def search_users(name, page = 0)
      params = { displayNamePrefix: name }
      response = post("/User/Search/GlobalName/#{page}", params).body
      return [] if response.nil?

      search_results = response.dig('Response', 'searchResults')
      return [] if search_results.nil?

      search_results.map do |user|
        Restiny::User.new(
          display_name: user['bungieGlobalDisplayName'],
          display_name_code: user['bungieGlobalDisplayNameCode'],
          memberships: user['destinyMemberships']
        )
      end
    end

    def get(endpoint_url, params = {})
      connection.get(API_BASE_URL + endpoint_url, params)
    end

    def post(endpoint_url, body, headers = {})
      connection.post(API_BASE_URL + endpoint_url, body, headers) 
    end

    private

    def parse_profile_characters_response(response)
      characters = response.body.dig('Response', 'characters', 'data')
      return [] if characters.nil?

      result = []

      [].tap do |result|
        characters.each_value do |character|
          result << Restiny::Character.new(
            id: character['characterId'],
            session_playtime: character['minutesPlayedThisSession'],
            total_playtime: character['minutesPlayedTotal'],
            light_level: character['light'],
            stats: [],
            emblem: [],
            progression: character['progression']
          )
        end
      end
    end

    def default_headers
      {
        'User-Agent': "restiny v#{Restiny::VERSION}",
        'X-API-KEY': @api_key
      }
    end

    def connection
      @connection ||= Faraday.new(headers: default_headers) do |faraday|
        faraday.request :json
        faraday.request :url_encoded
        faraday.response :json
        faraday.response :follow_redirects
        faraday.response :raise_error
      end
    end
  end
end

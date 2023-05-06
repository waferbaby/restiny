# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require 'restiny/version'
require 'restiny/constants'
require 'restiny/errors'
require 'restiny/manifest'
require 'restiny/user'
require 'restiny/membership'
require 'restiny/character'

require 'faraday'
require 'faraday/follow_redirects'
require 'securerandom'

module Restiny
  extend self

  BUNGIE_URL = "https://www.bungie.net"
  API_BASE_URL = BUNGIE_URL + "/platform"

  attr_accessor :api_key, :oauth_state, :oauth_client_id, :access_token, :refresh_token, :manifest

  # OAuth methods

  def authorise_url(redirect_url = nil, state = nil)
    check_oauth_client_id

    @oauth_state = state || SecureRandom.hex(15)

    params = {
      response_type: 'code',
      client_id: @oauth_client_id,
      state: @oauth_state
    }

    params[:redirect_url] = redirect_url unless redirect_url.nil?

    connection.build_url(BUNGIE_URL + "/en/oauth/authorize", params).to_s
  end

  def request_access_token(code, redirect_url = nil)
    check_oauth_client_id

    params = {
      code: code,
      grant_type: 'authorization_code',
      client_id: @oauth_client_id
    }

    params[:redirect_url] = redirect_url unless redirect_url.nil?

    post('/platform/app/oauth/token/', params, "Content-Type" => "application/x-www-form-urlencoded")
  end

  def request_refresh_token
  end

  # Manifest methods

  def download_manifest(locale = 'en')
    response = get("/platform/Destiny2/Manifest/")

    manifest_path = response.dig('Response', 'mobileWorldContentPaths', locale)
    raise Restiny::Error.new("Unable to determine manifest URL") if manifest_path.nil?

    Manifest.download(BUNGIE_URL + manifest_path)
  end

  # Profile methods

  def get_profile(membership_id, membership_type, components = [])
    raise Restiny::Error.new("You must provide at least one component") if components.empty?

    component_query = components.join(",")
    response = get("/platform/Destiny2/#{membership_type}/Profile/#{membership_id}?components=#{component_query}")

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
    raise Restiny::Error.new("You must provide a valid Bungie name") if display_name.nil? || display_name_code.nil?

    params = {
      displayName: display_name,
      displayNameCode: display_name_code
    }

    response = post("/platform/Destiny2/SearchDestinyPlayerByBungieName/#{membership_type}/", params)
    result = response.dig('Response')

    return [] if result.nil?

    Restiny::User.new(
      display_name: result[0]['bungieGlobalDisplayName'],
      display_name_code: result[0]['bungieGlobalDisplayNameCode'],
      memberships: result
    )
  end

  def search_users(name, page = 0)
    response = post("/platform/User/Search/GlobalName/#{page}", displayNamePrefix: name)
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

  def get(endpoint_url, params = {}, headers = {})
    make_api_request(:get, endpoint_url, params, headers)
  end

  def post(endpoint_url, body, headers = {})
    make_api_request(:post, endpoint_url, body, headers)
  end

  private

  def make_api_request(type, url, params, headers = {})
    raise Restiny::Error.new("You need to set an API key (Restiny.api_key = XXX)") unless @api_key

    headers[:authorization] = "Bearer #{@oauth_token}" if @oauth_token

    response = case type
               when :get
                 connection.get(url, params, headers)
               when :post
                 connection.post(url, params, headers)
               end

    # look at the status, raise an exception if it's not a 200
    # check for rate limiting here, etc.

    response.body
  end

  def parse_profile_characters_response(response)
    characters = response.dig('Response', 'characters', 'data')
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

  def check_oauth_client_id
    raise Restiny::Error.new("You need to set an OAuth client ID (Restiny.oauth_client_id = XXX)") unless @oauth_client_id
  end

  def default_headers
    {
      'User-Agent': "restiny v#{Restiny::VERSION}",
      'X-API-KEY': @api_key
    }
  end

  def connection
    @connection ||= Faraday.new(url: API_BASE_URL, headers: default_headers) do |faraday|
      faraday.request :json
      faraday.request :url_encoded
      faraday.response :json
      faraday.response :follow_redirects
      faraday.response :raise_error
    end
  end
end

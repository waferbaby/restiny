# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require 'restiny/version'
require 'restiny/constants'
require 'restiny/errors'
require 'restiny/manifest'

require 'faraday'
require 'faraday/follow_redirects'
require 'faraday/destiny/api'
require 'faraday/destiny/auth'

require 'down'
require 'json'
require 'securerandom'
require 'zip'

module Restiny
  extend self

  BUNGIE_URL = 'https://www.bungie.net'
  API_BASE_URL = "#{BUNGIE_URL}/platform".freeze

  attr_accessor :api_key, :oauth_state, :oauth_client_id, :access_token, :user_agent

  # OAuth methods

  def get_authorise_url(redirect_url: nil, state: nil)
    check_oauth_client_id

    @oauth_state = state || SecureRandom.hex(15)

    params = { response_type: 'code', client_id: @oauth_client_id, state: @oauth_state }
    params['redirect_url'] = redirect_url unless redirect_url.nil?

    auth_connection.build_url("#{BUNGIE_URL}/en/oauth/authorize/", params).to_s
  end

  def request_access_token(code:, redirect_url: nil)
    check_oauth_client_id

    params = { code: code, grant_type: 'authorization_code', client_id: @oauth_client_id }
    params['redirect_url'] = redirect_url unless redirect_url.nil?

    auth_connection.post('app/oauth/token/', params).body
  end

  # Manifest methods

  def download_manifest(locale: 'en', force_download: false)
    result = api_get('Destiny2/Manifest/')
    raise Restiny::ResponseError, 'Unable to determine manifest details' if result.nil?

    live_version = result['version']

    @manifests ||= {}
    @manifest_versions ||= {}

    if force_download || @manifests[locale].nil? || @manifest_versions[locale] != live_version
      manifest_db_url = result.dig('mobileWorldContentPaths', locale)
      raise Restiny::RequestError, 'Unknown locale' if manifest_db_url.nil?

      zipped_file = Down.download(BUNGIE_URL + manifest_db_url)
      database_file_path = "#{zipped_file.path}.db"

      Zip::File.open(zipped_file) { |file| file.first.extract(database_file_path) }

      @manifests[locale] = Manifest.new(database_file_path, live_version)
      @manifest_versions[locale] = live_version
    end

    @manifests[locale]
  rescue Down::Error => e
    raise Restiny::NetworkError.new('Unable to download the manifest file', e.response.code)
  rescue Zip::Error => e
    raise Restiny::Error, "Unable to unzip the manifest file (#{e})"
  end

  # Profile and related methods

  def get_profile(membership_id:, membership_type:, components:, type_url: nil)
    if !components.is_a?(Array) || components.empty?
      raise Restiny::InvalidParamsError, 'Please provide at least one component'
    end

    url = "Destiny2/#{membership_type}/Profile/#{membership_id}/"
    url += type_url if type_url
    url += "?components=#{components.join(',')}"

    api_get(url)
  end

  def get_character_profile(character_id:, membership_id:, membership_type:, components:)
    get_profile(
      membership_id: membership_id,
      membership_type: membership_type,
      components: components,
      type_url: "Character/#{character_id}/"
    )
  end

  def get_instanced_item_profile(item_id:, membership_id:, membership_type:, components:)
    get_profile(
      membership_id: membership_id,
      membership_type: membership_type,
      components: components,
      type_url: "Item/#{item_id}/"
    )
  end

  # User methods.

  def get_user_memberships_by_id(membership_id, membership_type: Platform::ALL)
    raise Restiny::InvalidParamsError, 'Please provide a membership ID' if membership_id.nil?

    api_get("User/GetMembershipsById/#{membership_id}/#{membership_type}/")
  end

  def get_user_primary_membership(parent_membership_id, use_fallback: true)
    result = get_user_memberships_by_id(parent_membership_id)
    return nil if result.nil? || result['primaryMembershipId'].nil?

    result['destinyMemberships'].each do |membership|
      return membership if membership['membershipID'] == result['primaryMembershipId']
    end

    result['destinyMemberships'][0] if use_fallback
  end

  def search_player_by_bungie_name(name, membership_type: Platform::ALL)
    display_name, display_name_code = name.split('#')
    if display_name.nil? || display_name_code.nil?
      raise Restiny::InvalidParamsError, 'You must provide a valid Bungie name'
    end

    api_post(
      "Destiny2/SearchDestinyPlayerByBungieName/#{membership_type}/",
      params: {
        displayName: display_name,
        displayNameCode: display_name_code
      }
    )
  end

  def search_users_by_global_name(name, page: 0)
    api_post("User/Search/GlobalName/#{page}/", params: { displayNamePrefix: name })
  end

  # General request methods

  def api_get(url, params: {})
    api_connection.get(url, params, token_header).body
  end

  def api_post(url, params: {})
    api_connection.post(url, params, token_header).body
  end

  private

  def check_oauth_client_id
    raise Restiny::RequestError, 'You need to set an OAuth client ID' unless @oauth_client_id
  end

  def default_headers
    { 'User-Agent': @user_agent || "restiny v#{Restiny::VERSION}" }
  end

  def api_connection
    raise Restiny::InvalidParamsError, 'You need to set an API key' unless @api_key

    @connection ||=
      Faraday.new(
        url: API_BASE_URL,
        headers: default_headers.merge('X-API-KEY': @api_key)
      ) do |faraday|
        faraday.request :json
        faraday.response :follow_redirects
        faraday.response :destiny_api
        faraday.response :json
      end
  end

  def auth_connection
    @auth_connection ||=
      Faraday.new(url: API_BASE_URL, headers: default_headers) do |faraday|
        faraday.request :url_encoded
        faraday.response :follow_redirects
        faraday.response :destiny_auth
        faraday.response :json
      end
  end

  def token_header
    {}.tap { |headers| headers['authorization'] = "Bearer #{@access_token}" if @access_token }
  end
end

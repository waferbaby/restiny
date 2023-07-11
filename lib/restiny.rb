# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require "restiny/version"
require "restiny/constants"
require "restiny/errors"
require "restiny/manifest"

require "faraday"
require "faraday/follow_redirects"
require "faraday/destiny/api"
require "faraday/destiny/auth"

require "down"
require "json"
require "securerandom"
require "zip"

module Restiny
  extend self

  BUNGIE_URL = "https://www.bungie.net"
  API_BASE_URL = BUNGIE_URL + "/platform"

  attr_accessor :api_key, :oauth_state, :oauth_client_id, :access_token

  # OAuth methods

  def get_authorise_url(redirect_url: nil, state: nil)
    check_oauth_client_id

    @oauth_state = state || SecureRandom.hex(15)

    params = { response_type: "code", client_id: @oauth_client_id, state: @oauth_state }
    params["redirect_url"] = redirect_url unless redirect_url.nil?

    auth_connection.build_url(BUNGIE_URL + "/en/oauth/authorize/", params).to_s
  end

  def request_access_token(code:, redirect_url: nil)
    check_oauth_client_id

    params = { code: code, grant_type: "authorization_code", client_id: @oauth_client_id }
    params["redirect_url"] = redirect_url unless redirect_url.nil?

    auth_post("app/oauth/token/", params)
  end

  # Manifest methods

  def get_manifest(locale: "en", force_download: false)
    result = api_get("Destiny2/Manifest/")
    raise Restiny::ResponseError.new("Unable to determine manifest details") if result.nil?

    live_version = result.dig("version")

    if force_download || @manifest.nil? || @manifest_version != live_version
      url = BUNGIE_URL + result.dig("mobileWorldContentPaths", locale)

      zipped_file = Down.download(url)
      database_file_path = zipped_file.path + ".db"

      Zip::File.open(zipped_file) { |file| file.first.extract(database_file_path) }

      @manifest = Manifest.new(database_file_path, live_version)
      @manifest_version = live_version
    end

    @manifest
  rescue Down::Error => e
    raise Restiny::NetworkError.new("Unable to download the manifest file", error.response.code)
  rescue Zip::Error => error
    raise Restiny::Error.new("Unable to unzip the manifest file (#{error})")
  end

  # Profile and related methods

  def get_profile(membership_id:, membership_type:, components:, type_url: nil)
    if !components.is_a?(Array) || components.empty?
      raise Restiny::InvalidParamsError.new("Please provide at least one component")
    end

    url = "Destiny2/#{membership_type}/Profile/#{membership_id}/"
    url += type_url if type_url
    url += "?components=#{components.join(",")}"

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
    raise Restiny::InvalidParamsError.new("Please provide a membership ID") if membership_id.nil?
    api_get("User/GetMembershipsById/#{membership_id}/#{membership_type}/")
  end

  def search_player_by_bungie_name(name, membership_type: Platform::ALL)
    display_name, display_name_code = name.split("#")
    if display_name.nil? || display_name_code.nil?
      raise Restiny::InvalidParamsError.new("You must provide a valid Bungie name")
    end

    api_post(
      "Destiny2/SearchDestinyPlayerByBungieName/#{membership_type}/",
      params: {
        displayName: display_name,
        displayNameCode: display_name_code
      }
    )
  end

  def search_users_by_global_name(name:, page: 0)
    api_post("User/Search/GlobalName/#{page}/", params: { displayNamePrefix: name })
  end

  # General request methods

  def api_get(url, params: {})
    api_connection.get(url, params, token_header).body
  end

  def api_post(url, params: {})
    api_connection.post(url, params, token_header).body
  end

  def auth_post(url, params)
    auth_connection.post(url, params, "Content-Type" => "application/x-www-form-urlencoded").body
  end

  private

  def check_oauth_client_id
    raise Restiny::RequestError.new("You need to set an OAuth client ID") unless @oauth_client_id
  end

  def default_headers
    { "User-Agent": "restiny v#{Restiny::VERSION}" }
  end

  def api_connection
    raise Restiny::InvalidParamsError.new("You need to set an API key") unless @api_key

    @connection ||=
      Faraday.new(
        url: API_BASE_URL,
        headers: default_headers.merge("X-API-KEY": @api_key)
      ) do |faraday|
        faraday.request :url_encoded
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
        faraday.request :json
        faraday.response :follow_redirects
        faraday.response :destiny_auth
        faraday.response :json
      end
  end

  def token_header
    {}.tap { |headers| headers["authorization"] = "Bearer #{@oauth_token}" if @oauth_token }
  end
end

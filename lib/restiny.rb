# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require "restiny/version"
require "restiny/constants"
require "restiny/errors"
require "restiny/manifest"

require "faraday"
require "faraday/follow_redirects"
require "faraday/destiny/api"
require "securerandom"

module Restiny
  extend self

  BUNGIE_URL = "https://www.bungie.net"
  API_BASE_URL = BUNGIE_URL + "/platform"

  attr_accessor :api_key, :oauth_state, :oauth_client_id, :access_token, :refresh_token, :manifest

  # OAuth methods

  def get_authorise_url(redirect_url: nil, state: nil)
    check_oauth_client_id

    @oauth_state = state || SecureRandom.hex(15)

    params = { response_type: "code", client_id: @oauth_client_id, state: @oauth_state }
    params[:redirect_url] = redirect_url unless redirect_url.nil?

    connection.build_url(BUNGIE_URL + "/en/oauth/authorize", params).to_s
  end

  def request_access_token(code:, redirect_url: nil)
    check_oauth_client_id

    params = { code: code, grant_type: "authorization_code", client_id: @oauth_client_id }
    params[:redirect_url] = redirect_url unless redirect_url.nil?

    connection.post(
      "app/oauth/token",
      params,
      "Content-Type" => "application/x-www-form-urlencoded"
    ).body
  end

  # Manifest methods

  def get_manifest_url(locale: "en")
    result = connection.get("Destiny2/Manifest/").body.dig("mobileWorldContentPaths", locale)
    BUNGIE_URL + result
  end

  def download_manifest(locale: "en")
    manifest_url = get_manifest_url
    raise Restiny::ResponseError.new("Unable to determine manifest URL") if manifest_url.nil?

    Manifest.download_by_url(BUNGIE_URL + manifest_url)
  end

  # Profile and related methods

  def get_profile(membership_id:, membership_type:, components:, type_url: nil)
    if !components.is_a?(Array) || components.empty?
      raise Restiny::InvalidParamsError.new("Please provide at least one component")
    end

    url = "Destiny2/#{membership_type}/Profile/#{membership_id}/"
    url += type_url if type_url
    url += "?components=#{components.join(",")}"

    connection.get(url).body
  end

  def get_character_profile(character_id:, membership_id:, membership_type:, components:)
    get_profile(
      membership_id: membership_id,
      membership_type: membership_type,
      components: components,
      type_url: "Character/#{character_id}"
    )
  end

  def get_instanced_item_profile(item_id:, membership_id:, membership_type:, components:)
    get_profile(
      membership_id: membership_id,
      membership_type: membership_type,
      components: components,
      type_url: "Item/#{item_id}"
    )
  end

  # User methods.

  def get_user_memberships_by_id(membership_id, membership_type: Platform::ALL)
    raise Restiny::InvalidParamsError.new("Please provide a membership ID") if membership_id.nil?

    connection.get("User/GetMembershipsById/#{membership_id}/#{membership_type}/").body
  end

  def search_player_by_bungie_name(name, membership_type: Platform::ALL)
    display_name, display_name_code = name.split("#")
    if display_name.nil? || display_name_code.nil?
      raise Restiny::InvalidParamsError.new("You must provide a valid Bungie name")
    end

    connection.post(
      "Destiny2/SearchDestinyPlayerByBungieName/#{membership_type}/",
      displayName: display_name,
      displayNameCode: display_name_code
    ).body
  end

  def search_users_by_global_name(name:, page: 0)
    connection.post("User/Search/GlobalName/#{page}", displayNamePrefix: name).body
  end

  # General request methods

  private

  def check_oauth_client_id
    raise Restiny::RequestError.new("You need to set an OAuth client ID") unless @oauth_client_id
  end

  def default_headers
    {
      "User-Agent": "restiny v#{Restiny::VERSION}",
      "X-API-KEY": @api_key,
      "Content-Type": "application/json"
    }
  end

  def connection
    raise Restiny::InvalidParamsError.new("You need to set an API key") unless @api_key

    headers = default_headers
    headers["authorization"] = "Bearer #{@oauth_token}" if @oauth_token

    Faraday.new(url: API_BASE_URL, headers: headers) do |faraday|
      faraday.request :url_encoded
      faraday.request :json
      faraday.response :follow_redirects
      faraday.response :destiny_api
    end
  end
end

# frozen_string_literal: true

require_relative 'base'

require 'tmpdir'
require 'uri'

module Restiny
  module Api
    module Manifest
      include Base

      def fetch_manifest
        result = get(endpoint: '/Destiny2/Manifest/')
        return result unless result.nil?

        raise Restiny::ResponseError, 'Unable to fetch manifest details'
      end

      def download_manifest_json(locale: 'en', definitions: [])
        raise Restiny::InvalidParamsError, 'No definitions provided' unless valid_array_param?(definitions)
        raise Restiny::InvalidParamsError, 'Unknown definitions provided' unless known_definitions?(definitions)

        paths = fetch_manifest.dig('jsonWorldComponentContentPaths', locale)
        raise Restiny::ResponseError, "Unable to find manifest JSON for locale '#{locale}'" if paths.nil?

        {}.tap do |files|
          definitions.each do |definition|
            files[definition] = download_manifest_json_by_url(url: BUNGIE_URL + paths[definition])
          end
        end
      end

      def known_definitions?(definitions)
        definitions.difference(Restiny::ManifestDefinition.values).empty?
      end

      def download_manifest_json_by_url(url:)
        filename = URI(url).path.split('/').last
        path = File.join(Dir.tmpdir, filename)

        HTTPX.get(url).copy_to(path)
        raise Restiny::Error, "Unable to download JSON from #{url}" unless File.exist?(path)

        path
      rescue HTTPX::Error
        raise Restiny::ResponseError, "Unable to download #{definition} JSON file"
      end
    end
  end
end

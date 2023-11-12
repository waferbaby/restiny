# frozen_string_literal: true

require_relative 'base'

require 'down'
require 'tmpdir'
require 'zip'

module Restiny
  module Api
    module Manifest
      include Base

      def download_manifest(locale: 'en', force_download: false)
        result = api_get(endpoint: 'Destiny2/Manifest/')
        raise Restiny::ResponseError, 'Unable to determine manifest details' if result.nil?

        live_version = result['version']

        @manifests ||= {}
        @manifest_versions ||= {}

        if force_download || @manifests[locale].nil? || @manifest_versions[locale] != live_version
          manifest_db_url = result.dig('mobileWorldContentPaths', locale)
          raise Restiny::RequestError, 'Unknown locale' if manifest_db_url.nil?

          database_file_path = extract_manifest_from_zip_file(
            Down.download(BUNGIE_URL + manifest_db_url),
            live_version
          )

          @manifests[locale] = Restiny::Manifest.new(database_file_path, live_version)
          @manifest_versions[locale] = live_version
        end

        @manifests[locale]
      rescue Down::Error => e
        raise Restiny::NetworkError.new('Unable to download the manifest file', e.response.code)
      rescue Zip::Error => e
        raise Restiny::Error, "Unable to unzip the manifest file (#{e})"
      end

      def extract_manifest_from_zip_file(source_path, version)
        Zip::File.open(source_path) do |zip_file|
          File.join(Dir.tmpdir, "#{version}.en.content.db").tap do |path|
            zip_file.first.extract(path) unless File.exist?(path)
          end
        end
      end
    end
  end
end

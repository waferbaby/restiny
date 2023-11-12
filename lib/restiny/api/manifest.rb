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

        return manifests[locale] if !force_download && manifest_version?(locale, result['version'])

        manifests[locale] = download_manifest_by_url(result.dig('mobileWorldContentPaths', locale), result['version'])
      end

      def download_manifest_by_url(url, version)
        raise Restiny::RequestError, 'Unknown locale' if url.nil?

        database_file_path = extract_manifest_from_zip_file(Down.download(BUNGIE_URL + url), version)

        Restiny::Manifest.new(database_file_path, version)
      rescue Down::Error => e
        raise Restiny::NetworkError.new('Unable to download the manifest file', e.response.code)
      end

      def extract_manifest_from_zip_file(source_path, version)
        Zip::File.open(source_path) do |zip_file|
          File.join(Dir.tmpdir, "#{version}.en.content.db").tap do |path|
            zip_file.first.extract(path) unless File.exist?(path)
          end
        end
      rescue Zip::Error => e
        raise Restiny::Error, "Unable to unzip the manifest file (#{e})"
      end

      def manifests
        @manifests ||= {}
      end

      def manifest_version?(locale, version)
        manifests[locale] && manifests[locale].version == version
      end
    end
  end
end

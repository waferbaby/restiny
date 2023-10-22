# frozen_string_literal: true

require 'spec_helper'

describe Restiny do
  describe '#download_manifest', vcr: { cassette_name: 'restiny/download_manifest' } do
    let(:locale) { 'en' }
    let(:manifest_url) {
      "https://www.bungie.net/common/destiny2_content/sqlite/#{locale}/world_sql_content_#{manifest_hash}.content"
    }

    before do
      zip_path = File.join(__dir__, 'data', 'manifest', locale, 'manifest.zip')

      if File.exist?(zip_path)
        body = File.read(zip_path)
        status = 200
      else
        body = nil
        status = 404
      end

      stub_request(:get, manifest_url).to_return(body: body, status: status)
    end

    context 'without a locale' do
      let(:manifest_hash) { '82c377013bea4b9c80747756ba4d9726' }

      it 'downloads the default English manifest' do
        subject.download_manifest
        assert_requested(:get, manifest_url)
      end
    end

    context 'with a given locale' do
      let(:manifest_hash) { '230929be68cd6ca4dd169ff4d9b07831' }
      let(:locale) { 'fr' }

      it 'download the correct manifest' do
        subject.download_manifest(locale: 'fr')
        assert_requested(:get, manifest_url)
      end
    end

    context 'with an invalid locale' do
      let(:manifest_hash) { 'cb9297065f50c42348c9ac04679420e7' }
      let(:locale) { 'hive' }

      it 'raises an error' do
        expect { subject.download_manifest(locale: locale) }.to raise_error(Restiny::RequestError, 'Unknown locale')
      end
    end

    context 'with a file that no longer exists' do
      let(:manifest_hash) { 'a1bcaffd9fd418cfdd80176695f1f9c0' }
      let(:locale) { 'pl' }

      it 'raises an error' do
        expect {
          subject.download_manifest(locale: locale)
        }.to raise_error(Restiny::NetworkError,
                         'Unable to download the manifest file')
      end
    end
  end
end

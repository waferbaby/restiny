# frozen_string_literal: true

require 'spec_helper'

describe Restiny do
  include_context 'with api calls'

  describe '#download_manifest', vcr: { cassette_name: 'restiny/download_manifest' } do
    let(:locale) { 'en' }
    let(:manifest_file_path) { File.join(__dir__, 'data', 'manifest', "#{locale}.content.db") }
    let(:manifest_url) do
      "https://www.bungie.net/common/destiny2_content/sqlite/#{locale}/world_sql_content_#{manifest_hash}.content"
    end

    context 'without a locale' do
      let(:manifest_hash) { '82c377013bea4b9c80747756ba4d9726' }

      it 'downloads the default English manifest' do
        allow(Down).to receive(:download)
        expect(Zip::File).to receive(:open).and_return(manifest_file_path)

        subject.download_manifest
      end
    end

    context 'with a given locale' do
      let(:manifest_hash) { '230929be68cd6ca4dd169ff4d9b07831' }
      let(:locale) { 'fr' }

      it 'downloads the correct manifest' do
        expect(Down).to receive(:download)
        expect(Zip::File).to receive(:open).and_return(manifest_file_path)

        subject.download_manifest(locale: 'fr')
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
        expect do
          subject.download_manifest(locale: locale)
        end.to raise_error(Restiny::NetworkError,
                           'Unable to download the manifest file')
      end
    end
  end

  describe '#get_profile', vcr: { cassette_name: 'restiny/get_profile' } do
    let(:profile_response) do
      subject.get_profile(membership_id: membership_id, membership_type: membership_type, components: components)
    end

    context 'with an invalid component' do
      let(:components) { ['babydog'] }

      it 'raises an error' do
        expect do
          profile_response
        end.to raise_error(Restiny::ResponseError,
                           'Unable to parse your parameters.  Please correct them, and try again.')
      end
    end
  end
end

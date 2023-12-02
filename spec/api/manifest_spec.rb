# frozen_string_literal: true

require 'spec_helper'

describe Restiny do
  include_context 'with api calls'

  describe '#fetch_manifest', vcr: { cassette_name: 'fetch_manifest' } do
    let(:manifest) { described_class.fetch_manifest }

    it 'returns all the correct top-level fields' do
      expect(manifest.keys).to eql(%w[version mobileAssetContentPath mobileGearAssetDataBases mobileWorldContentPaths
                                      jsonWorldContentPaths jsonWorldComponentContentPaths mobileClanBannerDatabasePath
                                      mobileGearCDN iconImagePyramidInfo])
    end

    it 'returns a valid version' do
      expect(manifest['version']).to match(/\d{6}\.\d{2}\.\d{2}\.\d{2}\.\d{4}-\d-bnet\.\d{5}/)
    end
  end
end

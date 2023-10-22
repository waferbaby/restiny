# frozen_string_literal: true

require 'spec_helper'

describe Restiny do
  describe '#get_manifest', vcr: { cassette_name: 'restiny/get_manifest' } do
    let(:manifest_pattern) do
      Regexp.new(
        "https://www.bungie.net/common/destiny2_content/sqlite/#{locale}/world_sql_content_([a-z0-9]+).content"
      )
    end

    context 'without a locale' do
      it 'returns the correct manifest' do
        manifest = subject.get_manifest

        puts manifest
      end
    end

    context 'with a given locale' do
      it 'returns the correct manifest' do
        manifest = subject.get_manifest(locale: 'fr')

        puts manifest
      end
    end
  end
end

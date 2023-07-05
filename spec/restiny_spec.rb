require "spec_helper"

describe Restiny do
  describe "#get_manifest_url", vcr: { cassette_name: "restiny/get_manifest_url" } do
    let(:manifest_pattern) do
      Regexp.new(
        "https://www.bungie.net/common/destiny2_content/sqlite/#{locale}/world_sql_content_([a-z0-9]+).content"
      )
    end

    context "without a locale" do
      let(:locale) { "en" }

      it "returns a valid URL for the English manifest" do
        expect(subject.get_manifest_url).to match(manifest_pattern)
      end
    end

    context "with a given locale" do
      let(:locale) { "fr" }

      it "returns the correct URL" do
        expect(subject.get_manifest_url(locale: locale)).to match(manifest_pattern)
      end
    end
  end
end

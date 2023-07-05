require "spec_helper"

describe Restiny do
  describe "#get_manifest_url", vcr: { cassette_name: "restiny/get_manifest_url" } do
    context "without a locale" do
      it "returns a valid URL for the English manifest" do
        expect(subject.get_manifest_url).to start_with(
          "https://www.bungie.net/common/destiny2_content/sqlite/en/world_sql_content_"
        )
      end
    end

    context "with a given locale" do
      it "returns the correct URL" do
        expect(subject.get_manifest_url(locale: "fr")).to start_with(
          "https://www.bungie.net/common/destiny2_content/sqlite/fr/world_sql_content_"
        )
      end
    end
  end
end

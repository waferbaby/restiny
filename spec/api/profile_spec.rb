# frozen_string_literal: true

require 'spec_helper'

describe Restiny do
  include_context 'with api calls'

  describe '#get_profile' do
    let(:profile_response) do
      described_class.get_profile(membership_id: membership_id, membership_type: membership_type,
                                  components: components)
    end

    let(:component_source) { JSON.parse(File.read(File.join(__dir__, 'data', 'components.json')))['components'] }

    context 'with an invalid component', vcr: { cassette_name: 'profile/invalid' } do
      let(:components) { ['babydog'] }

      it 'raises an error' do
        expect { profile_response }.to raise_error(
          Restiny::ResponseError,
          'ParameterParseFailure (7): Unable to parse your parameters.  Please correct them, and try again.'
        )
      end
    end

    Restiny::ComponentType.constants.map(&:downcase).each do |component|
      context "with the #{component} component", vcr: { cassette_name: "profile/components/#{component}" } do
        let(:components) { [Restiny::ComponentType.const_get(component.upcase)] }

        it 'returns the correct response' do
          expected_keys = %w[responseMintedTimestamp secondaryComponentsMintedTimestamp]
          component_keys = component_source[component.to_s]
          expected_keys.concat(component_keys) unless component_keys.nil?

          expect(profile_response.keys).to eql(expected_keys)
        end
      end
    end
  end
end

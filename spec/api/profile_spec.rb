# frozen_string_literal: true

require 'spec_helper'

describe Restiny do
  include_context 'with api calls'

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

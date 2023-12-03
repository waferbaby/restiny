# frozen_string_literal: true

require 'spec_helper'

describe Restiny do
  include_context 'with api calls'

  describe '#get_post_game_carnage_report', vcr: { cassette_name: 'stats/pgcr' } do
    let(:pgcr_response) { subject.get_post_game_carnage_report(activity_id: activity_id) }

    context 'with a nil activity id' do
      let(:activity_id) { nil }

      it 'raises an error' do
        expect { pgcr_response }.to raise_error(Restiny::InvalidParamsError, 'Please provide an activity ID')
      end
    end

    context 'with a non-integer activity id' do
      let(:activity_id) { 'fred' }

      it 'raises an error' do
        expect { pgcr_response }.to raise_error(
          Restiny::ResponseError,
          'ParameterParseFailure (7): Unable to parse your parameters.  Please correct them, and try again.'
        )
      end
    end

    context 'with a non-existent, but valid, activity id' do
      let(:activity_id) { 0o0000000000 }

      it 'raises an error' do
        expect { pgcr_response }.to raise_error(
          Restiny::RequestError,
          'DestinyPGCRNotFound (1653): The activity you were looking for was not found.'
        )
      end
    end

    context 'with an existing known activity id' do
      let(:activity_id) { 14_024_618_384 }

      it 'returns the correct PGCR' do
        expect(pgcr_response).to include('period' => '2023-11-02T09:32:00Z') # correct timestamp for activity_id 14024618384
      end
    end
  end
end

# frozen_string_literal: true

require 'restiny'
require 'vcr'
require 'webmock/rspec'
require 'simplecov'

SimpleCov.start

Restiny.api_key = ENV.fetch('DESTINY_API_KEY')
Restiny.oauth_client_id = ENV.fetch('DESTINY_OAUTH_CLIENT_ID')

VCR.configure do |c|
  c.cassette_library_dir = File.join(__dir__, 'cassettes')
  c.default_cassette_options = { serialize_with: :json }

  c.define_cassette_placeholder('<API_KEY>') { ENV.fetch('DESTINY_API_KEY') }
  c.define_cassette_placeholder('<OAUTH_CLIENT_ID>') { ENV.fetch('DESTINY_OAUTH_CLIENT_ID') }

  c.hook_into :faraday

  c.before_record { |interaction| interaction.response.headers.delete('set-cookie') }

  c.configure_rspec_metadata!
end

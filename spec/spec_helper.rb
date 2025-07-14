# frozen_string_literal: true

require 'simplecov'

SimpleCov.start

require 'dotenv'
require 'restiny'
require 'rspec'
require 'vcr'
require 'webmock/rspec'
require 'httpx/adapters/webmock'

Dotenv.load('.env.test')

Restiny.api_key = ENV.fetch('DESTINY_API_KEY')
Restiny.oauth_client_id = ENV.fetch('DESTINY_OAUTH_CLIENT_ID')

VCR.configure do |c|
  c.cassette_library_dir = File.join(__dir__, 'cassettes')
  c.default_cassette_options = { serialize_with: :json, record: :new_episodes }

  c.define_cassette_placeholder('<API_KEY>') { ENV.fetch('DESTINY_API_KEY') }
  c.define_cassette_placeholder('<OAUTH_CLIENT_ID>') { ENV.fetch('DESTINY_OAUTH_CLIENT_ID') }

  c.hook_into :webmock

  c.before_record do |interaction|
    interaction.response.headers.delete('Set-Cookie')
  end

  c.before_playback do |interaction|
    interaction.response.headers.delete('Content-Encoding')
  end

  c.configure_rspec_metadata!
end

shared_context('with api calls') do
  let(:membership_id) { 4_611_686_018_462_034_842 }
  let(:membership_type) { 2 }
  let(:character_id) { 2_305_843_009_316_446_082 }
end

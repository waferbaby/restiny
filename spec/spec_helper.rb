require "restiny"
require "vcr"

Restiny.api_key = ENV["DESTINY_API_KEY"]
Restiny.oauth_client_id = ENV["DESTINY_OAUTH_CLIENT_ID"]

VCR.configure do |c|
  c.cassette_library_dir = File.join(__dir__, "cassettes")
  c.default_cassette_options = { serialize_with: :json }

  c.define_cassette_placeholder("<API_KEY>") { ENV["DESTINY_API_KEY"] }
  c.define_cassette_placeholder("<OAUTH_CLIENT_ID>") { ENV["DESTINY_OAUTH_CLIENT_ID"] }

  c.hook_into :faraday

  c.before_record { |interaction| interaction.response.headers.delete("set-cookie") }

  c.configure_rspec_metadata!
end

# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__)

require 'restiny/version'
require 'restiny/api/authentication'
require 'restiny/api/manifest'
require 'restiny/api/membership'
require 'restiny/api/profile'
require 'restiny/api/search'
require 'restiny/api/stats'

# The main Restiny module.
module Restiny
  extend self

  include Api::Authentication
  include Api::Manifest
  include Api::Membership
  include Api::Profile
  include Api::Search
  include Api::Stats
end

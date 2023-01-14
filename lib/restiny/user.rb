# frozen_string_literal: true

module Restiny
  class User
    attr_reader :display_name, :display_name_code, :memberships

    def initialize(display_name:, display_name_code:, memberships:)
      @display_name = display_name
      @display_name_code = display_name_code
      
      self.memberships = memberships
    end

    def memberships=(raw_memberships)
      @memberships = {}

      raw_memberships.each do |ship|
        platform = Restiny::Membership.platform(ship['membershipType'])

        @memberships[platform] = Restiny::Membership.new(
          id: ship['membershipId'],
          type: ship['membershipType'],
          cross_save_override: ship['crossSaveOverride'],
          icon_path: ship['iconPath'],
          is_public: ship['isPublic'],
          types: ship['applicableMembershipTypes']
        )
      end
    end
  end
end

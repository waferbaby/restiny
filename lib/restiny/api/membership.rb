# frozen_string_literal: true

require_relative 'base'

module Restiny
  module Api
    module Membership
      include Base

      def get_user_memberships_by_id(membership_id, membership_type: Platform::ALL)
        raise Restiny::InvalidParamsError, 'Please provide a membership ID' if membership_id.nil?
        raise Restiny::InvalidParamsError, 'Please provide a membership type' if membership_type.nil?

        get("/User/GetMembershipsById/#{membership_id}/#{membership_type}/")
      end

      def get_primary_user_membership(membership_id, use_fallback: true)
        raise Restiny::InvalidParamsError, 'Please provide a membership ID' if membership_id.nil?

        result = get_user_memberships_by_id(membership_id)
        return nil if result.nil?

        unless result['primaryMembershipId'].nil?
          result['destinyMemberships'].each do |membership|
            return membership if membership['membershipID'] == result['primaryMembershipId']
          end
        end

        result['destinyMemberships'][0] if use_fallback
      end
    end
  end
end

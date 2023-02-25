# frozen_string_literal: true

# Serializer for guests
class GuestSerializer < ApplicationSerializer
  set_id :email

  attributes :email,
             :first_name,
             :last_name,
             :phone_numbers
end

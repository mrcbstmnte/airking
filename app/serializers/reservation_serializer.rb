# frozen_string_literal: true

# Serializer for reservations
class ReservationSerializer < ApplicationSerializer
  set_id :code

  attributes :adults,
             :children,
             :code,
             :currency,
             :end_date,
             :guest_information,
             :guests,
             :infants,
             :nights,
             :payout_price,
             :security_price,
             :start_date,
             :status,
             :total_price

  attribute :guest_information, if: proc { |_entity, params|
    params[:is_reservations]
  } do |entity|
    {
      email: entity.guest.email,
      first_name: entity.guest.first_name,
      last_name: entity.guest.last_name,
      phone_numbers: entity.guest.phone_numbers
    }
  end
end

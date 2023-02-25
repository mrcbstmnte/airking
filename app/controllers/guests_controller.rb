# frozen_string_literal: true

# Guests controller
class GuestsController < ApplicationController
  def index
    response = GuestServices::List.run

    render Utils::Response.new(
      response: response,
      serializer: GuestSerializer
    ).to_h
  end

  def reservations
    response = GuestServices::Reservations.run(params: params)

    render Utils::Response.new(
      response: response,
      serializer: ReservationSerializer
    ).to_h
  end
end

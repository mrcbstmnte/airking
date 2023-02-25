# frozen_string_literal: true

# Reservations controller
class ReservationsController < ApplicationController
  def index
    response = ReservationServices::List.run

    render Utils::Response.new(
      response: response,
      serializer: ReservationSerializer
    ).to_h
  end

  def create
    path_params = request.path_parameters

    response = ReservationServices::Create.run(
      params: params.except(*path_params.keys).permit!.to_h
    )

    render Utils::Response.new(
      response: response,
      serializer: ReservationSerializer,
      opts: {
        is_reservations: true
      }
    ).to_h
  end
end

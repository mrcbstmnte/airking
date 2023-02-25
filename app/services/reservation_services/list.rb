# frozen_string_literal: true

module ReservationServices
  # Service to list all reservations
  class List < ApplicationService
    def perform
      Reservation.all
    end
  end
end

# frozen_string_literal: true

module Payloads
  # Base class for payload management
  class Base
    def initialize(params)
      @params = params
      @skema = schema.call(params)
    end

    def process
      Guest.transaction do
        save_guest if guest.nil?

        raise ReservationAssociationError if associated_to_user?

        save_reservation
      end

      reservation
    end

    def errors
      @skema
        .errors(full: true)
        .to_h
    end

    def match?
      @skema.success?
    end

    private

    def associated_to_user?
      Reservation
        .where(code: reservation_code)
        .where.not(guest_id: guest.id)
        .exists?
    end

    def create_reservation
      @reservation = Reservation.create(
        {
          code: reservation_code,
          guest: @guest
        }.merge(reservation_entities)
      )
    end

    def save_guest
      @guest = Guest.create(guest_entities)
    end

    def save_reservation
      return update_reservation unless reservation.nil?

      create_reservation
    end

    def update_reservation
      @reservation = @guest.reservations.update(reservation.id, reservation_entities)
    end

    def guest
      @guest ||= Guest.find_by(email: guest_email)
    end

    def reservation
      @reservation ||= Reservation.find_by(code: reservation_code)
    end

    def guest_email
      raise NotImplementedError
    end

    def guest_entities
      raise NotImplementedError
    end

    def reservation_entities
      raise NotImplementedError
    end

    def reservation_code
      raise NotImplementedError
    end

    def schema
      raise NotImplementedError
    end
  end
end

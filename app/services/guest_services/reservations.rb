# frozen_string_literal: true

module GuestServices
  # Service to list all guests
  class Reservations < ApplicationService
    class GuestNotFoundError < StandardError; end
    class ParameterRequiredError < StandardError; end

    arguments :params

    def perform
      raise ParameterRequiredError unless params[:email].present?
      raise GuestNotFoundError if guest.nil?

      Reservation.where(guest_id: guest.id)
    rescue ParameterRequiredError
      Utils::ErrorResponses::InvalidAttribute.create_errors(
        errors: {
          email: ['email should be filled']
        }
      )
    rescue GuestNotFoundError
      Utils::ErrorResponses::ResourceNotFound.create(
        detail: "Guest with email '#{params[:email]}' was not found."
      )
    end

    private

    def guest
      @guest ||= Guest.find_by(email: params[:email])
    end
  end
end

# frozen_string_literal: true

module ReservationServices
  # Service to create a reservation
  class Create < ApplicationService
    arguments :params

    PAYLOADS = [
      Payloads::Bowking,
      Payloads::Abnb
    ].freeze

    def perform
      validation_errors = []

      PAYLOADS.each do |klass|
        @payload = klass.new(params)

        unless @payload.errors.empty?
          validation_errors.push(
            Utils::AttributeErrorParser.new(@payload.errors).parse
          )
        end

        return @payload.process if @payload.match?
      end

      Utils::ErrorResponses::InvalidAttribute.create_errors(
        # Get the error with the lesser count as it can
        #  represent a much accurate errors depending on
        #  payload.
        errors: validation_errors.min_by(&:count)
      )
    rescue ReservationAssociationError
      Utils::ErrorResponses::InvalidAssociation.create(
        detail: 'The reservation is already associated to another guest.'
      )
    end
  end
end

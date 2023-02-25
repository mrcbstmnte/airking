# frozen_string_literal: true

module Payloads
  # Class for Abnb-ish payload
  class Abnb < Base
    Hash.include CoreExtensions::Hash::DeepFetch

    private

    def guest_email
      @params.fetch_nested('reservation.guest_email')
    end

    def guest_entities
      {
        email: @params.fetch_nested('reservation.guest_email'),
        first_name: @params.fetch_nested('reservation.guest_first_name'),
        last_name: @params.fetch_nested('reservation.guest_last_name'),
        phone_numbers: @params.fetch_nested('reservation.guest_phone_numbers')
      }
    end

    def reservation_entities
      {
        start_date: @params.fetch_nested('reservation.start_date'),
        end_date: @params.fetch_nested('reservation.end_date'),
        adults: @params.fetch_nested('reservation.guest_details.number_of_adults'),
        children: @params.fetch_nested('reservation.guest_details.number_of_children'),
        infants: @params.fetch_nested('reservation.guest_details.number_of_infants'),
        guests: @params.fetch_nested('reservation.number_of_guests'),
        status: @params.fetch_nested('reservation.status_type'),
        nights: @params.fetch_nested('reservation.nights'),
        currency: @params.fetch_nested('reservation.host_currency'),
        payout_price: @params.fetch_nested('reservation.expected_payout_amount'),
        security_price: @params.fetch_nested('reservation.listing_security_price_accurate'),
        total_price: @params.fetch_nested('reservation.total_paid_amount_accurate')
      }
    end

    def reservation_code
      @params.fetch_nested('reservation.code')
    end

    def schema
      @schema ||= Dry::Schema.JSON do
        required(:reservation).hash do
          required(:code).filled(:string)
          required(:start_date).filled(:string)
          required(:end_date).filled(:string)
          required(:expected_payout_amount).filled(:string)

          required(:guest_details).hash do
            required(:localized_description).filled(:string)

            required(:number_of_adults).filled(:integer)
            required(:number_of_children).filled(:integer)
            required(:number_of_infants).filled(:integer)
          end

          required(:guest_email).filled(:string)
          required(:guest_first_name).filled(:string)
          required(:guest_last_name).filled(:string)

          required(:guest_phone_numbers).array(:str?)

          required(:listing_security_price_accurate).filled(:string)
          required(:host_currency).filled(:string)

          required(:nights).filled(:integer)
          required(:number_of_guests).filled(:integer)
          required(:status_type).filled(:string)
          required(:total_paid_amount_accurate).filled(:string)
        end
      end
    end
  end
end

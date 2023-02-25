# frozen_string_literal: true

module Payloads
  class Bowking < Base
    Hash.include CoreExtensions::Hash::DeepFetch

    private

    def guest_email
      @params.fetch_nested('guest.email')
    end

    def guest_entities
      {
        email: @params.fetch_nested('guest.email'),
        first_name: @params.fetch_nested('guest.first_name'),
        last_name: @params.fetch_nested('guest.last_name'),
        phone_numbers: [@params.fetch_nested('guest.phone')]
      }
    end

    def reservation_entities
      {
        start_date: @params.fetch_nested('start_date'),
        end_date: @params.fetch_nested('end_date'),
        adults: @params.fetch_nested('adults'),
        children: @params.fetch_nested('children'),
        infants: @params.fetch_nested('infants'),
        guests: @params.fetch_nested('guests'),
        status: @params.fetch_nested('status'),
        nights: @params.fetch_nested('nights'),
        currency: @params.fetch_nested('currency'),
        payout_price: @params.fetch_nested('payout_price'),
        security_price: @params.fetch_nested('security_price'),
        total_price: @params.fetch_nested('total_price')
      }
    end

    def reservation_code
      @params.fetch_nested('reservation_code')
    end

    def schema
      @schema ||= Dry::Schema.JSON do
        required(:reservation_code).filled(:string)
        required(:start_date).filled(:string)
        required(:end_date).filled(:string)

        required(:nights).filled(:integer)
        required(:guests).filled(:integer)
        required(:adults).filled(:integer)
        required(:children).filled(:integer)
        required(:infants).filled(:integer)

        required(:currency).filled(:string)
        required(:payout_price).filled(:string)
        required(:security_price).filled(:string)
        required(:total_price).filled(:string)
        required(:status).filled(:string)

        required(:guest).hash do
          required(:first_name).filled(:string)
          required(:last_name).filled(:string)
          required(:phone).filled(:string)
          required(:email).filled(:string)
        end
      end
    end
  end
end

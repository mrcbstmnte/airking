# frozen_string_literal: true

require 'rails_helper'

describe GuestServices::Reservations do
  let(:email) { 'm@bnb.com' }
  let(:guest_id) { 1 }

  let(:arguments) do
    {
      params: {
        email: email
      }
    }
  end
  let(:guest) do
    double(
      id: guest_id
    )
  end

  subject { described_class.new(arguments).perform }

  describe '#perform' do
    context 'when validating parameters' do
      context 'when email is not provided' do
        let(:email) { nil }
        let(:error_response) { double }

        it 'returns an invalid attribute error' do
          expect(Utils::ErrorResponses::InvalidAttribute).to receive(:create_errors)
            .with(
              errors: {
                email: ['email should be filled']
              }
            )
            .and_return(error_response)

          is_expected.to eq(error_response)
        end
      end
    end

    context 'when processing the request' do
      let(:guest_reservations) { double }

      it 'returns all reservations of the guest' do
        expect(Guest).to receive(:find_by)
          .with(email: email)
          .and_return(guest)

        expect(Reservation).to receive(:where)
          .with(guest_id: guest_id)
          .and_return(guest_reservations)

        is_expected.to eq(guest_reservations)
      end

      context 'when the the email provided was not found as guest' do
        let(:resource_not_found_error) { double }

        it 'returns a resource not found error' do
          expect(Utils::ErrorResponses::ResourceNotFound).to receive(:create)
            .with(
              detail: "Guest with email '#{email}' was not found."
            )
            .and_return(resource_not_found_error)

          is_expected.to eq(resource_not_found_error)
        end
      end
    end
  end
end

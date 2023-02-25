# frozen_string_literal: true

require 'rails_helper'

describe Payloads::Base do
  let(:association_exists?) { false }
  let(:created_guest) { double(id: guest_id) }
  let(:guest) { double(id: guest_id) }
  let(:guest_id) { 1 }
  let(:reservation) { double(id: reservation_id) }
  let(:reservation_id) { 2 }
  let(:schema) { double }

  let(:params) do
    {
      reservation_code: 'XXXYYY',
      adults: 1,
      children: 1,
      currency: 'AUD',
      start_date: 'start_date',
      end_date: 'end_date',
      guests: 2,
      infants: 0,
      nights: 1,
      payout_price: '100',
      security_price: '10',
      total_price: '110',
      status: 'approved',
      guest: {
        first_name: 'Bob',
        last_name: 'Strong',
        email: 'bob@bnb.com'
      }
    }
  end

  before do
    allow(Dry::Schema).to receive(:JSON)
      .and_return(schema)
    allow(schema).to receive(:call)
    allow(Guest).to receive(:find_by)
      .and_return(guest)
    allow(Reservation).to receive(:find_by)
      .and_return(nil)
    allow(Reservation).to receive(:create)
      .and_return(reservation)
    allow(Reservation).to receive_message_chain(:where, :where, :not, :exists?)
      .and_return(association_exists?)
    allow(guest).to receive_message_chain(:reservations, :update)
      .and_return(reservation)
  end

  after { |test| subject unless test.metadata[:skip_after] }

  # Using Bowking class as subject to test the overall
  #  implementation of the base class
  subject(:base_subject) { Payloads::Bowking.new(params) }

  describe '#process' do
    subject { base_subject.process }

    context 'when the reservation is already associated to another guest', skip_after: true do
      let(:association_exists?) { true }

      it 'raises a ReservationAssociationError' do
        expect(Reservation).to receive(:where)
          .with(code: 'XXXYYY')

        expect(Reservation).to receive_message_chain(:where, :where)
          .with(no_args)

        expect(Reservation).to receive_message_chain(:where, :where, :not)
          .with(guest_id: guest_id)

        expect(Reservation).to receive_message_chain(:where, :where, :not, :exists?)
          .with(no_args)

        expect { subject }.to raise_error ReservationAssociationError
      end
    end

    context 'when the guest is does not exist' do
      let(:guest) { nil }

      it 'saves the guest' do
        expect(Guest).to receive(:create)
          .with(
            hash_including(
              email: 'bob@bnb.com',
              first_name: 'Bob',
              last_name: 'Strong'
            )
          )
          .and_return(created_guest)
      end
    end

    context 'when the reservation already exists' do
      before do
        allow(Reservation).to receive(:find_by)
          .and_return(reservation)
      end

      it 'updates the reservation' do
        expect(guest).to receive(:reservations)
          .with(no_args)

        expect(guest).to receive_message_chain(:reservations, :update)
          .with(
            reservation_id,
            adults: 1,
            children: 1,
            currency: 'AUD',
            start_date: 'start_date',
            end_date: 'end_date',
            guests: 2,
            infants: 0,
            nights: 1,
            payout_price: '100',
            security_price: '10',
            total_price: '110',
            status: 'approved'
          )
      end
    end

    context 'when the reservation does not exist' do
      it 'creates a reservation' do
        expect(Reservation).to receive(:create)
          .with(
            code: 'XXXYYY',
            adults: 1,
            children: 1,
            currency: 'AUD',
            start_date: 'start_date',
            end_date: 'end_date',
            guests: 2,
            infants: 0,
            nights: 1,
            payout_price: '100',
            security_price: '10',
            total_price: '110',
            status: 'approved',
            guest: guest
          )
      end
    end
  end
end

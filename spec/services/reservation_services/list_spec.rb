# frozen_string_literal: true

require 'rails_helper'

describe ReservationServices::List do
  let(:reservations) { double }

  subject { described_class.new.perform }

  before do
    allow(Reservation).to receive(:all)
      .and_return(reservations)
  end

  describe '#perform' do
    context 'when processing the request' do
      it 'returns all the reservations' do
        expect(Reservation).to receive(:all)
          .with(no_args)

        is_expected.to eq(reservations)
      end
    end
  end
end

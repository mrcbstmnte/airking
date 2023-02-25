# frozen_string_literal: true

require 'rails_helper'

describe GuestServices::List do
  let(:guests) { double }

  subject { described_class.new.perform }

  before do
    allow(Guest).to receive(:all)
      .and_return(guests)
  end

  describe '#perform' do
    context 'when processing the request' do
      it 'returns all the guests' do
        expect(Guest).to receive(:all)
          .with(no_args)

        is_expected.to eq(guests)
      end
    end
  end
end

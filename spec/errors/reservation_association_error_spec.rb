# frozen_string_literal: true

require 'rails_helper'

describe ReservationAssociationError do
  it 'is a BaseError' do
    expect(described_class.superclass).to eq(StandardError)
  end
end

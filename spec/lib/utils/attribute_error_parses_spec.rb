# frozen_string_literal: true

require 'rails_helper'

describe Utils::AttributeErrorParser do
  let(:errors) do
    {
      reservation: {
        email: ['email should be filled'],
        first_name: ['first_name should be filled']
      },
      something: ['something should be filled']
    }
  end

  subject { described_class.new(errors).parse }

  describe '#parse' do
    it 'should return the parsed validation errors' do
      is_expected.to eq(
        [
          {
            detail: 'reservation.email should be filled'
          },
          {
            detail: 'reservation.first_name should be filled'
          },
          {
            detail: 'something should be filled'
          }
        ]
      )
    end
  end
end

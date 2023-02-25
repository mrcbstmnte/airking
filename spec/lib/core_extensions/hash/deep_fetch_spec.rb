# frozen_string_literal: true

require 'rails_helper'

describe CoreExtensions::Hash::DeepFetch do
  class Klass
    Hash.include CoreExtensions::Hash::DeepFetch

    def params
      {
        reservation: {
          guest_details: {
            name: {
              first: 'Bob'
            }
          },
          email: 'bob@bnb.com'
        }
      }
    end
  end

  describe '#fetch_nested' do
    subject { Klass.new }

    it 'fetches the value of the hash property with the given path' do
      expect(
        subject.params.fetch_nested('reservation.guest_details.name.first')
      ).to eq('Bob')

      expect(
        subject.params.fetch_nested('reservation.email')
      ).to eq('bob@bnb.com')
    end

    it 'returns nil when the specified path was not found' do
      expect(
        subject.params.fetch_nested('reservation.guest_details.name.last')
      ).to be_nil
    end
  end
end

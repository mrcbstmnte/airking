# frozen_string_literal: true

require 'rails_helper'

describe Utils::ErrorResponses::InvalidAssociation do
  it { expect(described_class::CODE).to eq(:invalid_association) }

  it 'returns http code 422' do
    expect(described_class::HTTP_CODE).to eq(422)
  end
end

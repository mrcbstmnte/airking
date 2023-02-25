# frozen_string_literal: true

require 'rails_helper'

describe Utils::ErrorResponses::InvalidAttribute do
  it { expect(described_class::CODE).to eq(:invalid_attribute) }

  it 'returns http code 409' do
    expect(described_class::HTTP_CODE).to eq(409)
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe Utils::ErrorResponses::ResourceNotFound do
  it { expect(described_class::CODE).to eq(:resource_not_found) }

  it 'returns http code 404' do
    expect(described_class::HTTP_CODE).to eq(404)
  end
end

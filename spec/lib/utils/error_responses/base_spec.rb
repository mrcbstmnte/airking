# frozen_string_literal: true

require 'rails_helper'

describe Utils::ErrorResponses::Base do
  class TestError < described_class
    CODE = :test_code
  end

  let(:attribute) { 'test_attribute' }
  let(:detail) { 'test_detail' }
  let(:resource_id) { 'test_id' }
  let(:error_double) { double('http_code=' => 400) }

  before do
    allow(Utils::ErrorResponses::Error).to receive(:new)
      .and_return(error_double)
    allow(error_double).to receive(:add)
  end

  after { subject }

  describe '.create' do
    let(:params) do
      {
        attribute: attribute,
        detail: detail,
        resource_id: resource_id
      }
    end

    subject { TestError.create(params) }

    context 'when attribute is nil' do
      let(:attribute) { nil }

      it 'adds an error without the attribute' do
        expect(error_double).to_not receive(:add).with(
          hash_including(
            :attribute
          )
        )
      end
    end

    context 'when resource_id is nil' do
      let(:resource_id) { nil }

      it 'adds an error without the resource_id' do
        expect(error_double).to_not receive(:add).with(
          hash_including(
            :resource_id
          )
        )
      end
    end

    context 'when all fields are provided' do
      it 'adds the proper payload' do
        expect(error_double).to receive(:add).with(
          hash_including(
            attribute: attribute,
            code: :test_code,
            detail: detail,
            resource_id: resource_id
          )
        )
      end
    end

    it 'returns an error' do
      is_expected.to eq(error_double)
    end
  end

  describe '.create_errors' do
    let(:error_detail) { 'email should be filled' }
    let(:params) do
      {
        errors: [
          {
            detail: error_detail
          }
        ]
      }
    end

    subject { TestError.create_errors(params) }

    context 'when all fields are provided' do
      it 'adds the proper payload' do
        expect(error_double).to receive(:add).with(
          hash_including(
            code: :test_code,
            detail: error_detail
          )
        )
      end
    end

    it 'returns an error' do
      is_expected.to eq(error_double)
    end
  end
end

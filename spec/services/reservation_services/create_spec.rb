# frozen_string_literal: true

require 'rails_helper'

describe ReservationServices::Create do
  # Override constant to test only one class
  described_class::PAYLOADS = [
    Payloads::Bowking
  ].freeze

  let(:payload_match?) { true }

  let(:arguments) do
    {
      params: params
    }
  end
  let(:params) do
    {
      reservation: {
        code: 'XXXXYYYY',
        start_date: '2023-02-01',
        end_date: '2023-02-11'
      }
    }
  end
  let(:payload_klass) do
    double(
      errors: validation_errors,
      match?: payload_match?
    )
  end
  let(:validation_errors) do
    {
      reservation: {
        email: ['email should be filled'],
        last_name: ['last_name should be filled']
      }
    }
  end

  before do
    allow(Payloads::Bowking).to receive(:new)
      .and_return(payload_klass)
  end

  subject { described_class.new(arguments).perform }

  describe '#perform' do
    context 'when provided payloads are invalid' do
      let(:error_response) { double }
      let(:parsed_errors) { [double] }
      let(:payload_match?) { false }

      let(:parser_instance) do
        double(
          parse: double
        )
      end

      it 'returns invalid attribute errors' do
        expect(Utils::AttributeErrorParser).to receive(:new)
          .with(validation_errors)
          .and_return(parser_instance)

        expect(parser_instance).to receive(:parse)
          .with(no_args)
          .and_return(parsed_errors)

        expect(Utils::ErrorResponses::InvalidAttribute).to receive(:create_errors)
          .with(
            errors: parsed_errors
          )
          .and_return(error_response)

        is_expected.to eq(error_response)
      end
    end

    context 'when processing the request' do
      let(:processed_reservation) { double }

      before do
        allow(payload_klass).to receive(:process)
          .and_return(processed_reservation)
      end

      it 'returns the processed reservation' do
        is_expected.to eq(processed_reservation)
      end

      context 'when a reservation association error occurred' do
        let(:invalid_association_error) { double }
        let(:validation_errors) { {} }

        before do
          allow(payload_klass).to receive(:process)
            .and_raise(ReservationAssociationError)
        end

        it 'returns an invalid association error response' do
          expect(Utils::ErrorResponses::InvalidAssociation).to receive(:create)
            .with(
              detail: 'The reservation is already associated to another guest.'
            )
            .and_return(invalid_association_error)

          is_expected.to eq(invalid_association_error)
        end
      end
    end
  end
end

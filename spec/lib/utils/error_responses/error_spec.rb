# frozen_string_literal: true

require 'rails_helper'

describe Utils::ErrorResponses::Error do
  let!(:args) do
    {
      attribute: 'some_attribute',
      code: 'some_code',
      detail: 'some_detail',
      resource_id: 'some_id',
      value: 'some_value'
    }
  end

  subject! { described_class.new }

  describe '#initialize' do
    it 'responds to to_h method' do
      expect(subject).to respond_to(:to_h)
    end

    it 'responds to to_a method' do
      expect(subject).to respond_to(:to_a)
    end

    it 'responds to merge method' do
      expect(subject).to respond_to(:merge)
    end

    it 'responds to empty? method' do
      expect(subject).to respond_to(:empty?)
    end

    it 'responds to attributes method' do
      expect(subject).to respond_to(:attributes)
    end

    it 'responds to add method' do
      expect(subject).to respond_to(:add)
    end

    it 'responds to http_code method' do
      expect(subject).to respond_to(:http_code)
    end
  end

  describe '#to_h' do
    it 'returns a hash' do
      expect(subject.to_h.keys).to contain_exactly(:errors)
    end
  end

  describe '#to_a' do
    context 'when error is not empty' do
      let(:common_mock) do
        subject.add(
          attribute: args[:attribute],
          code: args[:code],
          detail: args[:detail],
          resource_id: args[:resource_id]
        )
      end

      context 'when hash has an attribute key' do
        it 'removes the attribute key' do
          common_mock

          expect(subject.to_a[0].keys).to_not include(:attribute)
        end

        it 'returns an array' do
          expect(subject.to_a).to be_an(::Array)
        end
      end

      context 'when hash has a resource_id key' do
        context 'when resource_id is not empty' do
          it 'contains the resource_id details' do
            common_mock

            expect(subject.to_a[0].keys).to include(:resource_id)
          end
        end

        context 'when resource_id is empty' do
          it 'removes this resource_id details' do
            args[:resource_id] = ''
            common_mock

            expect(subject.to_a[0].keys).to_not include(:resource_id)
          end
        end
      end

      context 'when hash has a source key' do
        context 'when source pointer is empty' do
          context 'when source attribute is empty' do
            it 'removes the source key' do
              args[:attribute] = ''
              common_mock

              expect(subject.to_a[0].keys).to_not include(:source)
            end
          end

          context 'when source attribute is not empty' do
            it 'contains the source details' do
              common_mock

              expect(subject.to_a[0].keys).to include(:source)
            end
          end
        end
      end
    end
  end

  describe '#merge' do
    let(:error_to_merge) do
      error = described_class.new
      error.add(
        attribute: args[:attribute],
        code: args[:code],
        detail: args[:detail]
      )

      error
    end

    subject! do
      error = described_class.new

      error.merge(error_to_merge)
    end

    it 'calls to_a for the new error to merge' do
      allow(error_to_merge).to receive(:to_a).and_call_original

      expect(error_to_merge).to receive(:to_a).with(no_args)

      described_class.new.merge(error_to_merge)
    end

    it 'returns an array' do
      expect(subject).to be_an(::Array)
    end

    it 'returns the concatenated array' do
      expect(subject).to eq([{
                              code: args[:code],
                              detail: args[:detail],
                              source: {
                                pointer: '',
                                attribute: args[:attribute]
                              }
                            }])
    end
  end

  describe '#empty?' do
    context 'when error is empty' do
      subject do
        error = described_class.new

        error.empty?
      end

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when error is not empty' do
      subject do
        error = described_class.new

        error.add(
          attribute: args[:attribute],
          code: args[:code],
          detail: args[:detail]
        )

        error.empty?
      end

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end
  end

  describe '#attributes' do
    subject do
      error = described_class.new

      error.add(
        attribute: args[:attribute],
        code: args[:code],
        detail: args[:detail]
      )

      error.attributes
    end

    it 'returns an array' do
      expect(subject).to be_an(::Array)
    end

    it 'returns the list of attributes' do
      expect(subject).to eq([args[:attribute]])
    end
  end

  describe '#add' do
    subject do
      error = described_class.new

      error.add(
        attribute: args[:attribute],
        code: args[:code],
        detail: args[:detail],
        resource_id: args[:resource_id]
      )
    end

    it 'returns an array' do
      expect(subject).to be_an(::Array)
    end

    it 'returns the added error detail' do
      expect(subject).to eq([
                              attribute: args[:attribute],
                              code: args[:code],
                              detail: args[:detail],
                              resource_id: args[:resource_id],
                              source: {
                                pointer: '',
                                attribute: args[:attribute]
                              }
                            ])
    end
  end
end

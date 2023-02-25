# frozen_string_literal: true

module Utils
  module ErrorResponses
    # Defines logic for error handling
    class Error
      attr_accessor :http_code

      def initialize
        @errors = []
        @http_code = 400
      end

      def to_h
        {
          errors: to_a
        }
      end

      def to_a
        @errors.map do |error|
          error.reject do |key|
            key == :attribute ||
              (key == :source && error[key][:pointer].empty? && error[key][:attribute].empty?) ||
              (key == :resource_id && error[key].to_s.empty?)
          end
        end
      end

      def merge(errors)
        @errors.concat(errors.to_a)
      end

      def empty?
        @errors.empty?
      end

      def attributes
        @errors.map do |error|
          error[:attribute]
        end
      end

      def add(attribute: '', code: '', detail: '', resource_id: '')
        @errors.push(
          attribute: attribute,
          code: code,
          detail: detail,
          resource_id: resource_id,
          source: {
            pointer: '',
            attribute: attribute
          }
        )
      end
    end
  end
end

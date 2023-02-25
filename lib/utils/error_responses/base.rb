# frozen_string_literal: true

module Utils
  module ErrorResponses
    # Defines logic for base error responses
    class Base
      HTTP_CODE = 400

      def self.create(attribute: nil, detail: nil, resource_id: nil)
        error = ErrorResponses::Error.new

        error_payload = {
          code: self::CODE,
          detail: detail
        }

        error_payload[:attribute] = attribute unless attribute.nil?
        error_payload[:resource_id] = resource_id unless resource_id.nil?

        error.add(error_payload)
        error.http_code = self::HTTP_CODE

        error
      end

      def self.create_errors(errors: [])
        error = ErrorResponses::Error.new

        errors.each do |e|
          error.add(
            code: self::CODE,
            detail: e[:detail]
          )
        end

        error.http_code = self::HTTP_CODE

        error
      end
    end
  end
end

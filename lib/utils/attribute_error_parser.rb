# frozen_string_literal: true

module Utils
  class AttributeErrorParser
    def initialize(errors)
      @errors = errors
      @parsed_errors = []
    end

    def parse
      gather_error_details(
        errors: @errors,
        parsed: @parsed_errors
      )

      @parsed_errors
    end

    private

    def gather_error_details(errors: [], parsed: [], prev_key: nil)
      errors.each do |key, value|
        unless errors[key].is_a? Hash
          next parsed.push(
            detail: prev_key.nil? ? value.first : "#{prev_key}.#{value.first}"
          )
        end

        gather_error_details(
          errors: errors[key],
          parsed: parsed,
          prev_key: prev_key.nil? ? key : "#{prev_key}.#{key}"
        )
      end
    end
  end
end

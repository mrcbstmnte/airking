# frozen_string_literal: true

module Utils
  module ErrorResponses
    # Error response if payload attribute is not invalid
    class InvalidAttribute < Base
      CODE = :invalid_attribute
      HTTP_CODE = 409
    end
  end
end

# frozen_string_literal: true

module Utils
  module ErrorResponses
    # Error response if payload is not recognized
    class InvalidAssociation < Base
      CODE = :invalid_association
      HTTP_CODE = 422
    end
  end
end

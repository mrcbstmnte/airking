# frozen_string_literal: true

module Utils
  module ErrorResponses
    # Error response if a resource does not exist
    class ResourceNotFound < Base
      CODE = :resource_not_found
      HTTP_CODE = 404
    end
  end
end

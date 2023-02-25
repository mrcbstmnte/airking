# frozen_string_literal: true

module Utils
  # Handles response format
  class Response
    def initialize(response:, serializer: nil, opts: {})
      @response = response
      @serializer = serializer
      @opts = opts
    end

    def to_h
      if @response.is_a? ErrorResponses::Error
        {
          json: @response.to_h,
          status: @response.http_code
        }
      else
        {
          json: @serializer.new(
            @response,
            {
              params: @opts
            }
          ).serializable_hash,
          status: @opts[:http_code]
        }
      end
    end
  end
end

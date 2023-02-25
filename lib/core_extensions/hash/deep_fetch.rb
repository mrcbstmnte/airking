# frozen_string_literal: true

module CoreExtensions
  module Hash
    module DeepFetch
      def fetch_nested(path)
        extend Hashie::Extensions::DeepFetch

        symbolized_path = path
                          .split('.')
                          .map(&:to_sym)

        deep_fetch(*symbolized_path) { |_key| nil }
      end
    end
  end
end

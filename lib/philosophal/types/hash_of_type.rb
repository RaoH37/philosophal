# frozen_string_literal: true

module Philosophal
  module Types
    class HashOfType
      attr_reader :subtype

      def initialize(key_type, value_type)
        @subtype = { key_type:, value_type: }
      end

      def ===(hash)
        hash.is_a?(Hash) &&
          !hash.keys.find { |key| !key.is_a?(@subtype[:key_type]) } &&
          !hash.values.find { |value| !value.is_a?(@subtype[:value_type]) }
      end

      freeze
    end
  end
end

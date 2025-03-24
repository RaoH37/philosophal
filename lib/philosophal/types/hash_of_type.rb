# frozen_string_literal: true

module Philosophal
  module Types
    class HashOfType
      def self.instance(key_type, value_type)
        subtype = { key_type:, value_type: }
        memorization.fetch(Marshal.dump(subtype), new(subtype).freeze)
      end

      def self.memorization
        return @memorization if defined?(@memorization)

        @memorization = {}
      end

      attr_reader :subtype

      def initialize(subtype)
        @subtype = subtype.freeze
        self.class.memorization[Marshal.dump(subtype)] = self
      end

      def ===(hash)
        hash.is_a?(Hash) &&
          !hash.keys.find { |key| !key.is_a?(@subtype[:key_type]) } &&
          !hash.values.find { |value| !value.is_a?(@subtype[:value_type]) }
      end
    end
  end
end

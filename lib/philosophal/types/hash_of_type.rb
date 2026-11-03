# frozen_string_literal: true

module Philosophal
  module Types
    class HashOfType
      def self.instance(key_type, value_type)
        memorization[[key_type, value_type]] ||= new({ key_type:, value_type: }).freeze
      end

      def self.memorization
        return @memorization if defined?(@memorization)

        @memorization = {}
      end

      private_class_method :new

      attr_reader :subtype

      def initialize(subtype)
        @subtype = subtype.freeze
      end

      def ===(hash)
        return false unless hash.is_a?(Hash)

        key_type = @subtype[:key_type]
        value_type = @subtype[:value_type]
        hash.all? { |key, value| key.is_a?(key_type) && value.is_a?(value_type) }
      end
    end
  end
end

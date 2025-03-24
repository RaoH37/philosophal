# frozen_string_literal: true

module Philosophal
  module Types
    class ArrayOfType
      def self.instance(subtype)
        memorization.fetch(subtype, new(subtype).freeze)
      end

      def self.memorization
        return @memorization if defined?(@memorization)

        @memorization = {}
      end

      attr_reader :subtype

      def initialize(subtype)
        @subtype = subtype
        self.class.memorization[subtype] = self
      end

      def ===(array)
        array.is_a?(Array) && !array.find { |entry| !entry.is_a?(@subtype) }
      end
    end
  end
end

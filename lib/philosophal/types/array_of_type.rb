# frozen_string_literal: true

module Philosophal
  module Types
    class ArrayOfType
      MEMORIZATION = {}

      def self.instance(subtype)
        MEMORIZATION.fetch(subtype, new(subtype).freeze)
      end

      attr_reader :subtype

      def initialize(subtype)
        @subtype = subtype
        MEMORIZATION[subtype] = self
      end

      def ===(array)
        array.is_a?(Array) && !array.find { |entry| !entry.is_a?(@subtype) }
      end

      freeze
    end
  end
end

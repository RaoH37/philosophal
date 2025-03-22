# frozen_string_literal: true

module Philosophal
  module Types
    class ArrayOfType
      attr_reader :subtype

      def initialize(subtype)
        @subtype = subtype
      end

      def ===(array)
        array.is_a?(Array) && !array.find { |entry| !entry.is_a?(@subtype) }
      end

      freeze
    end
  end
end

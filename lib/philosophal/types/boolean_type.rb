# frozen_string_literal: true

module Philosophal
  module Types
    class BooleanType
      Instance = new.freeze

      TRUE_FALSE_SET = Set[true, false]

      def ===(value)
        true.equal?(value) || false.equal?(value)
      end

      freeze
    end
  end
end

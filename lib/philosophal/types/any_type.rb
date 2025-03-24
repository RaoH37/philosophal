# frozen_string_literal: true

module Philosophal
  module Types
    class AnyType
      Instance = new.freeze

      def ===(value)
        true
      end

      freeze
    end
  end
end

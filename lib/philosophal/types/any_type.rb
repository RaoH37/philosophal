# frozen_string_literal: true

module Philosophal
  module Types
    class AnyType
      Instance = new.freeze

      def ===(_value)
        true
      end

      freeze
    end
  end
end

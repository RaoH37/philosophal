# frozen_string_literal: true

module Philosophal
  module Types
    autoload :BooleanType, 'philosophal/types/boolean_type'
    autoload :ArrayOfType, 'philosophal/types/array_of_type'

    def _Boolean
      BooleanType::Instance
    end

    def _ArrayOf(subtype)
      ArrayOfType.new(subtype)
    end
  end
end

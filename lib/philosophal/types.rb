# frozen_string_literal: true

module Philosophal
  module Types
    autoload :BooleanType, 'philosophal/types/boolean_type'

    def _Boolean
      BooleanType::Instance
    end
  end
end

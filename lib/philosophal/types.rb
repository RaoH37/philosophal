module Philosophal::Types
  autoload :BooleanType, 'philosophal/types/boolean_type'

  def _Boolean
    BooleanType::Instance
  end
end
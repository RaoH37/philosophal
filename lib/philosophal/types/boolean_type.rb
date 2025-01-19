class Philosophal::Types::BooleanType
  Instance = new.freeze

  def ===(value)
    true == value || false == value
  end

  freeze
end
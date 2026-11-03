# frozen_string_literal: true

require 'date'
require 'pathname'
require 'time'
require 'json'

module Philosophal
  autoload :Convertor, 'philosophal/convertor'
  autoload :Transform, 'philosophal/transform'

  autoload :Properties, 'philosophal/properties'
  autoload :Property, 'philosophal/property'

  autoload :Types, 'philosophal/types'
  autoload :Loaders, 'philosophal/loaders'

  autoload :TypeError, 'philosophal/errors/type_error'
  autoload :ArgumentError, 'philosophal/errors/argument_error'

  def self.convert(property, value)
    # nil means "no value": it is neither converted nor transformed, so the reader falls back to the default.
    return if value.nil?

    converted = property.type === value ? value : convert_to_type(property, value) # rubocop:disable Style/CaseEquality
    return converted unless property.transform?

    Transform.make(property.transform, converted)
  end

  def self.convert_to_type(property, value)
    convert_method, subtype = property.convert_method
    raise Philosophal::TypeError unless convert_method

    if subtype
      Convertor.send(convert_method, value, subtype)
    else
      Convertor.send(convert_method, value)
    end
  end
  private_class_method :convert_to_type
end

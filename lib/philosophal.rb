# frozen_string_literal: true

require 'date'
require 'pathname'
require 'set'
require 'time'

module Philosophal
  autoload :Convertor, 'philosophal/convertor'
  autoload :Transform, 'philosophal/transform'

  autoload :Properties, 'philosophal/properties'
  autoload :Property, 'philosophal/property'

  autoload :Types, 'philosophal/types'

  autoload :TypeError, 'philosophal/errors/type_error'
  autoload :ArgumentError, 'philosophal/errors/argument_error'

  def self.convert(property, value)
    if property.type === value
      if property.transform?
        Transform.make(property.transform, value)
      else
        value
      end
    else
      convert_method, subtype = Convertor.convert_method_for(property.type)
      raise Philosophal::TypeError unless convert_method

      converted = if subtype
                    Convertor.send(convert_method, value, subtype)
                  else
                    Convertor.send(convert_method, value)
                  end

      return converted unless property.transform?

      Transform.make(property.transform, converted)
    end
  end
end

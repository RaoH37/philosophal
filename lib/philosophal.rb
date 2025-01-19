# frozen_string_literal: true

require 'date'
require 'pathname'
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
    # p property.type
    # p value
    if property.type === value
      if property.transform?
        Transform.make(property.transform, value)
      else
        value
      end
    else
      convert_method = Convertor::METHOD_TYPE_MAP[property.type]
      raise Philosophal::TypeError unless convert_method

      if property.transform?
        Transform.make(property.transform, Convertor.send(convert_method, value))
      else
        Convertor.send(convert_method, value)
      end
    end
  end
end

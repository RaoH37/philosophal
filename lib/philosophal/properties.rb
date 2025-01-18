# frozen_string_literal: true

module Philosophal
  module Properties
    autoload :Schema, 'philosophal/properties/schema'

    def cprop(name, type, default: nil, transform: nil, &coercion)
      if default && !(default.is_a?(Proc) || default.frozen?)
        default.freeze
      end

      if transform && !(transform.is_a?(Proc) || transform.is_a?(Symbol))
        raise Philosophal::ArgumentError, "transform param must be a Symbol object or a Proc (#{name})."
      end

      property = __philosophal_property_class__.new(
        name:,
        type:,
        default:,
        transform:,
        coercion:
      )

      philosophal_properties << property
      __define_philosophal_methods__(property)
      include(__philosophal_extension__)
    end

    def philosophal_properties
      return @philosophal_properties if defined?(@philosophal_properties)

      @philosophal_properties = if superclass.is_a?(Philosophal::Properties)
                                  superclass.philosophal_properties.dup
                                else
                                  Philosophal::Properties::Schema.new
                                end
    end

    private

    def __philosophal_property_class__
      Philosophal::Property
    end

    def __define_philosophal_methods__(new_property)
      code =	__generate_philosophal_methods__(new_property)
      __philosophal_extension__.module_eval(code)
    end

    def __philosophal_extension__
      if defined?(@__philosophal_extension__)
        @__philosophal_extension__
      else
        @__philosophal_extension__ = Module.new do
          # def initialize
          # 	after_initialize if respond_to?(:after_initialize)
          # end
          # def to_h
          # 		{}
          # end

          # set_temporary_name "Literal::Properties(Extension)" if respond_to?(:set_temporary_name)
        end
      end
    end

    def __generate_philosophal_methods__(new_property, buffer = +'')
      buffer << "# frozen_string_philosophal: true\n"
      new_property.generate_writer_method(buffer)
      new_property.generate_reader_method(buffer)

      # puts buffer

      buffer
    end
  end
end

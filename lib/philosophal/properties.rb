# frozen_string_literal: true

module Philosophal
  module Properties
    autoload :Schema, 'philosophal/properties/schema'

    include Philosophal::Types

    def cprop(name, type, default: nil, transform: nil)
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
        transform:
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
          def cprop?(property_name, klass)
            property = self.class.philosophal_properties.properties_index[property_name.to_sym]
            return false unless property

            klass = klass.class unless klass.is_a?(Class)
            property.type == klass
          end

          def philosophal_inspect(light = false)
            keys_map = philosophal_inspect_map

            if light
              keys_map.reject! do |_, v|
                v.nil? || (v.respond_to?(:empty?) && v.empty?)
              end
            end

            keys_str = keys_map.map { |k, v| [k, v.inspect].join(': ') }.join(', ')
            "#{self.class}:#{format('0x00%x', (object_id << 1))} #{keys_str}"
          end
          alias cprop_inspect philosophal_inspect

          def philosophal_inspect_map
            Hash[self.class.philosophal_properties.properties_index.values.map do |property|
              [
                property.name,
                self.send(property.name)
              ]
            end]
          end
          alias cprop_inspect_map philosophal_inspect_map
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

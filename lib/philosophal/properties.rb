# frozen_string_literal: true

module Philosophal
  module Properties
    autoload :Schema, 'philosophal/properties/schema'
    autoload :InstanceMethods, 'philosophal/properties/instance_methods'
    autoload :JSONLoader, 'philosophal/loaders/json_loader'

    include Philosophal::Types

    def cprop(name, type, default: nil, transform: nil, immutable: false, description: nil, json: false, override: true)
      __check_philosophal_options__(name, transform:, immutable:, override:, description:, json:)

      default.freeze unless default.is_a?(Proc)
      description&.freeze
      json = json.to_sym if json.is_a?(String)

      property = __philosophal_property_class__.new(
        name:, type:, default:, transform:, immutable:, description:, json:, override:
      )

      philosophal_properties << property
      __define_philosophal_methods__(property)
      include(__philosophal_extension__)
    end

    def philosophal_properties
      return @philosophal_properties if defined?(@philosophal_properties)

      @philosophal_properties = if defined?(superclass) && superclass.is_a?(Philosophal::Properties)
                                  superclass.philosophal_properties.dup
                                else
                                  Philosophal::Properties::Schema.new
                                end
    end

    def philosophal_descriptions
      return @philosophal_descriptions if defined?(@philosophal_descriptions)

      @philosophal_descriptions = philosophal_properties.properties_index.values
                                                        .select(&:description)
                                                        .to_h do |property|
        [
          property.name,
          property.description
        ]
      end
    end
    alias cprop_descriptions philosophal_descriptions

    def json
      return @json if defined?(@json)

      @json = Philosophal::Loaders::JsonLoader.new(self)
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
      @__philosophal_extension__ ||= Module.new { include Philosophal::Properties::InstanceMethods }
    end

    def __generate_philosophal_methods__(new_property)
      buffer = +''

      new_property.method_generators.each do |method_name, generator|
        next unless new_property.override? || !method_defined?(method_name)

        __remove_philosophal_own_method__(method_name) if new_property.override?
        new_property.public_send(generator, buffer)
      end

      # puts buffer
      return buffer if buffer.empty?

      +"# frozen_string_philosophal: true\n" << buffer
    end

    # Generated methods live in an included module, so a method defined in the class itself
    # would hide them: it is removed to let the property override it.
    def __remove_philosophal_own_method__(method_name)
      return unless method_defined?(method_name, false) || private_method_defined?(method_name, false)

      remove_method(method_name)
    end

    def __check_philosophal_options__(name, transform:, immutable:, override:, description:, json:)
      __check_philosophal_transform_option__(name, transform)
      __check_philosophal_boolean_option__(:override, override)
      __check_philosophal_boolean_option__(:immutable, immutable)

      if description && !description.is_a?(String)
        raise Philosophal::ArgumentError, 'description param must be a string.'
      end

      return if !json || json == true || json.is_a?(String) || json.is_a?(Symbol)

      raise Philosophal::ArgumentError, 'json param must be true or a String or a Symbol.'
    end

    def __check_philosophal_transform_option__(name, transform)
      return if !transform || transform.is_a?(Proc) || transform.is_a?(Symbol)

      raise Philosophal::ArgumentError, "transform param must be a Symbol object or a Proc (#{name})."
    end

    def __check_philosophal_boolean_option__(option_name, value)
      return if Philosophal::Types::BooleanType::TRUE_FALSE_SET.include?(value)

      raise Philosophal::ArgumentError, "#{option_name} param must be true or false."
    end
  end
end

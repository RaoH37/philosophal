# frozen_string_literal: true

module Philosophal
  class Property
    def initialize(name:, type:, default:, transform:, immutable:, description:, json:, override:,
                   track_changes: false)
      @name = name
      @type = type
      @default = default
      @transform = transform
      @immutable = immutable
      @description = description
      @json = json
      @override = override
      @track_changes = track_changes
    end

    attr_reader :name, :type, :default, :transform, :immutable, :description, :json, :override, :track_changes

    def json_name
      return @json if @json.is_a?(Symbol)

      @name
    end

    def default?
      @default != nil
    end

    def default_value
      case @default
      when Proc then @default.call
      else @default
      end
    end

    def transform?
      @transform != nil
    end

    def override?
      @override
    end

    def track_changes?
      @track_changes
    end

    def check_conversion(value)
      Philosophal.convert(self, value)
    end

    # The Convertor method (and subtype) for the type, looked up once since the type never changes.
    def convert_method
      return @convert_method if defined?(@convert_method)

      @convert_method = Philosophal::Convertor.convert_method_for(@type)
    end

    def method_generators
      generators = {
        writer_method_name => immutable ? :generate_immutable_writer_method : :generate_writer_method,
        reader_method_name => default? ? :generate_reader_method : :generate_plain_reader_method
      }
      generators[boolean_method_name] = :generate_boolean_method if type == Philosophal::Types::BooleanType::Instance
      generators[description_method_name] = :generate_description_method if description
      generators.merge(change_tracking_generators)
    end

    def change_tracking_generators
      return {} unless track_changes?

      { was_method_name => :generate_was_method, changed_method_name => :generate_changed_method }
    end

    def writer_method_name
      return @writer_method_name if defined? @writer_method_name

      @writer_method_name = :"#{@name.name}="
    end

    def generate_writer_method(buffer)
      buffer << <<~RUBY
        def #{writer_method_name.name}(value)
          @#{@name.name} = self.class.philosophal_properties[:#{@name.name}].check_conversion(value)
        rescue Philosophal::TypeError => error
          error.set_backtrace(caller(1))
          raise
        end
      RUBY
    end

    def generate_immutable_writer_method(buffer)
      buffer << <<~RUBY
        def #{writer_method_name.name}(value)
          raise FrozenError, "can't modify frozen variable @#{@name.name}" if defined?(@#{@name.name})
          @#{@name.name} = self.class.philosophal_properties[:#{@name.name}].check_conversion(value).freeze
        rescue Philosophal::TypeError => error
          error.set_backtrace(caller(1))
          raise
        end
      RUBY
    end

    def reader_method_name
      @name
    end

    def variable_name
      return @variable_name if defined? @variable_name

      @variable_name = :"@#{@name.name}"
    end

    # Without a default the reader only returns the variable: attr_reader is the fastest form.
    # The default is not looked up, so a subclass redeclaring the property with a default and
    # override: false keeps this reader and does not get its default (not supported).
    def generate_plain_reader_method(buffer)
      buffer << "attr_reader :#{reader_method_name.name}\n"
    end

    def generate_reader_method(buffer)
      buffer << <<~RUBY
        def #{reader_method_name.name}
          @#{@name.name}.nil? ? self.class.philosophal_properties[:#{@name.name}].default_value : @#{@name.name}
        end
      RUBY
    end

    def boolean_method_name
      return @boolean_method_name if defined? @boolean_method_name

      @boolean_method_name = :"#{@name.name}?"
    end

    def generate_boolean_method(buffer)
      buffer << <<~RUBY
        def #{boolean_method_name.name}
          !!#{reader_method_name.name}
        end
      RUBY
    end

    def description_method_name
      return @description_method_name if defined? @description_method_name

      @description_method_name = :"#{@name.name}_description"
    end

    def was_method_name
      return @was_method_name if defined? @was_method_name

      @was_method_name = :"#{@name.name}_was"
    end

    def was_variable_name
      return @was_variable_name if defined? @was_variable_name

      @was_variable_name = :"@__philosophal_#{@name.name}_was__"
    end

    # Returns the stored value at the last changes_applied (nil before), without falling back to the default.
    def generate_was_method(buffer)
      buffer << <<~RUBY
        def #{was_method_name.name}
          #{was_variable_name}
        end
      RUBY
    end

    def changed_method_name
      return @changed_method_name if defined? @changed_method_name

      @changed_method_name = :"#{@name.name}_changed?"
    end

    # True when the stored value differs from the one recorded at the last changes_applied.
    def generate_changed_method(buffer)
      buffer << <<~RUBY
        def #{changed_method_name.name}
          @#{@name.name} != #{was_variable_name}
        end
      RUBY
    end

    # The description is read from the schema rather than written into the generated code,
    # so it is never evaluated as Ruby.
    def generate_description_method(buffer)
      buffer << <<~RUBY
        def #{description_method_name.name}
          self.class.philosophal_properties[:#{@name.name}].description
        end
      RUBY
    end
  end
end

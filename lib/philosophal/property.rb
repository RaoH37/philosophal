# frozen_string_literal: true

module Philosophal
  class Property
    def initialize(name:, type:, default:, transform:, immutable:, description:, json:, override:)
      @name = name
      @type = type
      @default = default
      @transform = transform
      @immutable = immutable
      @description = description
      @json = json
      @override = override
    end

    attr_reader :name, :type, :default, :transform, :immutable, :description, :json, :override

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

    def check_conversion(value)
      Philosophal.convert(self, value)
    end

    def writer_method_name
      return @writer_method_name if defined? @writer_method_name

      @writer_method_name = :"#{@name.name}="
    end

    def generate_writer_method(buffer)
      buffer <<
        ' def ' << writer_method_name.name << "(value)\n  " \
                                         '@' << @name.name << ' = self.class.philosophal_properties[:' <<
        @name.name <<
        "].check_conversion(value)\n" \
        "rescue Philosophal::TypeError => error\n" \
        "error.set_backtrace(caller(1))\n  raise\n" \
        "end\n"
    end

    def generate_immutable_writer_method(buffer)
      buffer <<
        ' def ' << writer_method_name.name << "(value)\n  " \
                                 'raise FrozenError, "can\'t modify frozen variable @' <<
        @name.name << '" if defined?(@' << @name.name << ")\n" \
                                                         '@' << @name.name << ' = self.class.philosophal_properties[:' <<
        @name.name <<
        "].check_conversion(value).freeze\n" \
        "rescue Philosophal::TypeError => error\n" \
        "error.set_backtrace(caller(1))\n  raise\n" \
        "end\n"
    end

    def reader_method_name
      @name
    end

    def generate_reader_method(buffer)
      buffer <<
        ' def ' <<
        reader_method_name.name <<
        "\n  " \
        '@' << @name.name << ' || self.class.philosophal_properties[:' <<
        @name.name <<
        "].default_value\n" \
        "end\n"
    end

    def boolean_method_name
      return @boolean_method_name if defined? @boolean_method_name

      @boolean_method_name = :"#{@name.name}?"
    end

    def generate_boolean_method(buffer)
      buffer <<
        ' def ' <<
        boolean_method_name.name <<
        "\n  " \
        '!!@' << @name.name <<
        "\nend\n"
    end

    def description_method_name
      return @description_method_name if defined? @description_method_name

      @description_method_name = :"#{@name.name}_description"
    end

    def generate_description_method(buffer)
      buffer <<
        ' def ' <<
        description_method_name.name <<
        "\n  " \
        '%(' << @description << ')' \
                                "\nend\n"
    end
  end
end

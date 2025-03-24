# frozen_string_literal: true

module Philosophal
  class Property
    def initialize(name:, type:, default:, transform:, immutable:)
      @name = name
      @type = type
      @default = default
      @transform = transform
      @immutable = immutable
    end

    attr_reader :name, :type, :default, :transform, :immutable

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

    def check_conversion(value)
      Philosophal.convert(self, value)
    end

    def generate_writer_method(buffer = +'')
      buffer <<
        ' def ' << @name.name << "=(value)\n  " \
                                 '@' << @name.name << ' = self.class.philosophal_properties[:' <<
        @name.name <<
        "].check_conversion(value)\n" \
        "rescue Philosophal::TypeError => error\n" \
        "error.set_backtrace(caller(1))\n  raise\n" \
        "end\n"
    end

    def generate_immutable_writer_method(buffer = +'')
      buffer <<
        ' def ' << @name.name << "=(value)\n  " \
                                 'raise FrozenError, "can\'t modify frozen variable @' <<
        @name.name << '" if defined?(@' << @name.name << ")\n" \
                                                         '@' << @name.name << ' = self.class.philosophal_properties[:' <<
        @name.name <<
        "].check_conversion(value).freeze\n" \
        "rescue Philosophal::TypeError => error\n" \
        "error.set_backtrace(caller(1))\n  raise\n" \
        "end\n"
    end

    def generate_reader_method(buffer = +'')
      buffer <<
        ' def ' <<
        @name.name <<
        "\n  " \
        '@' << @name.name << ' || self.class.philosophal_properties[:' <<
        @name.name <<
        "].default_value\n" \
        "end\n"
    end

    def generate_boolean_method(buffer = +'')
      buffer <<
        ' def ' <<
        @name.name <<
        "?\n  " \
        '!!@' << @name.name <<
        "\nend\n"
    end
  end
end

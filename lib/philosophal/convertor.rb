# frozen_string_literal: true

module Philosophal
  class Convertor
    METHOD_TYPE_MAP = {
      Symbol => :convert_to_symbol,
      String => :convert_to_string,
      Integer => :convert_to_integer,
      Float => :convert_to_float,
      Array => :convert_to_array,
      Hash => :convert_to_hash,
      Time => :convert_to_time,
      Date => :convert_to_date,
      DateTime => :convert_to_date_time,
      Philosophal::Types::BooleanType::Instance => :convert_to_boolean,
      Philosophal::Types::ArrayOfType => :convert_to_array_of,
      Philosophal::Types::HashOfType => :convert_to_hash_of,
      Pathname => :convert_to_pathname
    }.freeze

    class << self
      def convert_method_for(type)
        if type.respond_to?(:subtype)
          [METHOD_TYPE_MAP[type.class], type.subtype]
        else
          METHOD_TYPE_MAP[type]
        end
      end

      def convert_to_symbol(obj)
        raise Philosophal::TypeError unless obj.respond_to?(:to_sym)

        obj.to_sym
      end

      def convert_to_string(obj)
        raise Philosophal::TypeError unless obj.respond_to?(:to_s)

        obj.to_s
      end

      def convert_to_integer(obj)
        raise Philosophal::TypeError unless obj.respond_to?(:to_i)

        obj.to_i
      end

      def convert_to_float(obj)
        raise Philosophal::TypeError unless obj.respond_to?(:to_f)

        obj.to_f
      end

      def convert_to_array(obj)
        if obj.respond_to?(:to_a)
          obj.to_a
        else
          [obj]
        end
      end

      def convert_to_hash(obj)
        raise Philosophal::TypeError unless obj.respond_to?(:to_h)

        obj.to_h
      end

      def convert_to_time(obj)
        return Time.zone.local(*obj) if obj.is_a?(Array)
        return Time.zone.parse(obj) if obj.is_a?(String)
        return Time.zone.at(obj) if obj.is_a?(Numeric)

        raise Philosophal::TypeError
      end

      def convert_to_date(obj)
        return obj.to_date if obj.respond_to?(:to_date)
        return Date.new(*obj) if obj.is_a?(Array)
        return Date.parse(obj) if obj.is_a?(String)
        return Time.zone.at(obj).to_date if obj.is_a?(Numeric)

        raise Philosophal::TypeError
      end

      def convert_to_date_time(obj)
        return obj.to_datetime if obj.respond_to?(:to_datetime)
        return DateTime.new(*obj) if obj.is_a?(Array)
        return DateTime.parse(obj) if obj.is_a?(String)
        return Time.zone.at(obj).to_datetime if obj.is_a?(Numeric)

        raise Philosophal::TypeError
      end

      def convert_to_boolean(obj)
        if obj.is_a?(Numeric)
          return true if obj == 1
          return false if obj.zero?

        elsif obj.is_a?(String)
          obj_downcase = obj.downcase
          return true if obj_downcase == 'true'
          return false if obj_downcase == 'false'

        end
        raise Philosophal::TypeError
      end

      def convert_to_pathname(obj)
        raise Philosophal::TypeError unless obj.respond_to?(:to_s)

        Pathname.new(obj)
      end

      def convert_to_array_of(obj, subtype)
        subtype_convert_method = convert_method_for(subtype)
        raise Philosophal::TypeError unless subtype_convert_method

        convert_to_array(obj).tap do |new_obj|
          new_obj.map! do |item|
            send(subtype_convert_method, item)
          end
        end
      end

      def convert_to_hash_of(obj, subtype)
        key_convert_method = convert_method_for(subtype[:key_type])
        raise Philosophal::TypeError unless key_convert_method

        value_convert_method = convert_method_for(subtype[:value_type])
        raise Philosophal::TypeError unless value_convert_method

        convert_to_hash(obj).tap do |new_obj|
          new_obj.transform_keys! { |key| send(key_convert_method, key) }
          new_obj.transform_values! { |value| send(value_convert_method, value) }
        end
      end
    end
  end
end

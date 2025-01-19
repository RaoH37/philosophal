# frozen_string_literal: true

module Philosophal
  class Convertor
    METHOD_TYPE_MAP = {
      String => :String,
      Integer => :Integer,
      Float => :Float,
      Array => :Array,
      Hash => :Hash,
      Time => :Time,
      Date => :Date,
      DateTime => :DateTime,
      Philosophal::Types::BooleanType::Instance => :Boolean,
      Pathname => :Pathname
    }.freeze

    class << self
      def String(obj)
        raise Philosophal::TypeError unless obj.respond_to?(:to_s)

        obj.to_s
      end

      def Integer(obj)
        raise Philosophal::TypeError unless obj.respond_to?(:to_i)

        obj.to_i
      end

      def Float(obj)
        raise Philosophal::TypeError unless obj.respond_to?(:to_f)

        obj.to_f
      end

      def Array(obj)
        if obj.respond_to?(:to_a)
          obj.to_a
        else
          [obj]
        end
      end

      def Hash(obj)
        raise Philosophal::TypeError unless obj.respond_to?(:to_h)

        obj.to_h
      end

      def Time(obj)
        return Time.zone.local(*obj) if obj.is_a?(Array)
        return Time.zone.parse(obj) if obj.is_a?(String)
        return Time.zone.at(obj) if obj.is_a?(Numeric)

        raise Philosophal::TypeError
      end

      def Date(obj)
        return obj.to_date if obj.respond_to?(:to_date)
        return Date.new(*obj) if obj.is_a?(Array)
        return Date.parse(obj) if obj.is_a?(String)
        return Time.zone.at(obj).to_date if obj.is_a?(Numeric)

        raise Philosophal::TypeError
      end

      def DateTime(obj)
        return obj.to_datetime if obj.respond_to?(:to_datetime)
        return DateTime.new(*obj) if obj.is_a?(Array)
        return DateTime.parse(obj) if obj.is_a?(String)
        return Time.zone.at(obj).to_datetime if obj.is_a?(Numeric)

        raise Philosophal::TypeError
      end

      def Boolean(obj)
        if obj.is_a?(Numeric)
          return true if obj == 1
          return false if obj == 0

          raise Philosophal::TypeError
        elsif obj.is_a?(String)
          obj_downcase = obj.downcase
          return true if obj_downcase == 'true'
          return false if obj_downcase == 'false'

          raise Philosophal::TypeError
        else
          raise Philosophal::TypeError
        end
      end

      def Pathname(obj)
        raise Philosophal::TypeError unless obj.respond_to?(:to_s)

        Pathname.new(obj)
      end
    end
  end
end

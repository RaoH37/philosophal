# frozen_string_literal: true

module Philosophal
  module Properties
    class Schema
      include Enumerable

      def initialize(properties_index: {})
        @properties_index = properties_index
        @mutex = Mutex.new
      end

      attr_reader :properties_index

      def [](key)
        @properties_index[key]
      end

      def keys
        @properties_index.keys
      end

      def <<(value)
        @mutex.synchronize do
          @properties_index[value.name] = value
        end

        self
      end

      def immutables
        return @immutables if defined?(@immutables)

        @immutables = @properties_index.select { |_, v| v.immutable }
      end

      def mutables
        return @mutables if defined?(@mutables)

        @mutables = @properties_index.reject { |_, v| v.immutable }
      end

      def json_names_h
        return @json_names_h if defined?(@json_names_h)

        @json_names_h = @properties_index.to_h do |key, property|
          [property.json_name, key]
        end
      end
    end
  end
end

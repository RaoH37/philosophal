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
        @properties_index.select { |_, v| v.immutable }
      end

      def mutables
        @properties_index.reject { |_, v| v.immutable }
      end
    end
  end
end

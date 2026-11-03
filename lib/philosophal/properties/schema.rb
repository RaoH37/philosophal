# frozen_string_literal: true

module Philosophal
  module Properties
    class Schema
      include Enumerable

      def initialize(properties_index: {})
        @properties_index = properties_index
        @mutex = Mutex.new
      end

      # Called by #dup: a subclass gets its own index, so its properties do not leak into the parent.
      def initialize_copy(source)
        super
        @properties_index = source.properties_index.dup
        @mutex = Mutex.new
        clear_caches
      end

      attr_reader :properties_index

      def [](key)
        @properties_index[key]
      end

      def keys
        @properties_index.keys
      end

      # Yields each property in declaration order; Enumerable builds on it.
      def each(&)
        return enum_for(:each) { @properties_index.size } unless block_given?

        @properties_index.each_value(&)
        self
      end

      def <<(value)
        @mutex.synchronize do
          @properties_index[value.name] = value
          clear_caches
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

      # Maps each JSON name to the writer of its property.
      def json_setters
        return @json_setters if defined?(@json_setters)

        @json_setters = @properties_index.each_value.to_h do |property|
          [property.json_name, property.writer_method_name]
        end
      end

      # Properties declared with json: (exported by to_json_hash).
      def json_properties
        return @json_properties if defined?(@json_properties)

        @json_properties = @properties_index.each_value.select(&:json)
      end

      # Properties declared with track_changes: true.
      def tracked
        return @tracked if defined?(@tracked)

        @tracked = @properties_index.each_value.select(&:track_changes?)
      end

      private

      def clear_caches
        %i[@immutables @mutables @json_names_h @json_setters @json_properties @tracked].each do |cache|
          remove_instance_variable(cache) if instance_variable_defined?(cache)
        end
      end
    end
  end
end

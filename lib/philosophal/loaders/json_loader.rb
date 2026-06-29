# frozen_string_literal: true

module Philosophal
  module Loaders
    class JsonLoader
      def initialize(klass)
        @klass = klass
      end

      def load(json)
        return load_from_hash(json) if json.is_a?(Hash)
        return load_from_array(json) if json.is_a?(Array)

        raise LoadError, 'invalid json parameter' unless json.is_a?(String)

        first_char = json[0]

        return load_from_json(json) if first_char == '{'

        return load_from_json_collection(json) if first_char == '['

        load_from_path(json)
      end

      private

      def load_from_array(array)
        raise LoadError, 'invalid json parameter' if array.find { |hash| !hash.is_a?(Hash) }

        array.map! do |hash|
          load_from_hash(hash)
        end
      end

      def load_from_hash(hash)
        obj = @klass.new

        hash.each_key do |key|
          setter = setter_from_key(key)
          next unless obj.respond_to?(setter)

          obj.public_send(setter, hash.delete(key))
        end

        obj
      end

      def setter_from_key(key)
        real_key = @klass.philosophal_properties.json_names_h[key]
        property = @klass.philosophal_properties[real_key]

        return :"#{property.name}=" if property

        :"#{key}="
      end

      def load_from_json(str)
        hash = JSON.parse(str, symbolize_names: true)
        load_from_hash(hash)
      end

      def load_from_json_collection(json)
        array = JSON.parse(json, symbolize_names: true)
        load_from_array(array)
      end

      def load_from_path(path)
        raise LoadError, "no such file #{path}" unless File.exist?(path)

        str = File.read(path)
        load_from_json(str)
      end
    end
  end
end

# frozen_string_literal: true

module Philosophal
  module Loaders
    class JSONLoader
      def initialize(klass)
        @klass = klass
      end

      def load(json)
        return load_from_hash(json) if json.is_a?(Hash)

        raise LoadError, 'invalid json parameter' unless json.is_a?(String)

        if json[0] == '{'
          load_from_json(json)
        else
          load_from_path(json)
        end
      end

      private

      def load_from_hash(hash)
        obj = @klass.new

        hash.each do |key, value|
          setter = :"#{key}="
          next unless obj.respond_to?(setter)

          obj.public_send(setter, value)
        end

        obj
      end

      def load_from_json(str)
        hash = JSON.parse(str, symbolize_names: true)
        load_from_hash(hash)
      end

      def load_from_path(path)
        raise LoadError, "no such file #{path}" unless File.exist?(path)

        str = File.read(path)
        load_from_json(str)
      end
    end
  end
end

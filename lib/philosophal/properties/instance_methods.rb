# frozen_string_literal: true

module Philosophal
  module Properties
    module InstanceMethods
      def cprop?(property_name, klass)
        property = self.class.philosophal_properties.properties_index[property_name.to_sym]
        return false unless property

        klass = klass.class unless klass.is_a?(Class)
        property.type == klass
      end

      def philosophal_inspect(light = false)
        keys_map = philosophal_inspect_map

        if light
          keys_map.reject! do |_, v|
            v.nil? || (v.respond_to?(:empty?) && v.empty?)
          end
        end

        keys_str = keys_map.map { |k, v| [k, v.inspect].join(': ') }.join(', ')
        "#{self.class}:#{format('0x00%x', object_id << 1)} #{keys_str}"
      end
      alias cprop_inspect philosophal_inspect

      def philosophal_inspect_map
        philosophal_values.to_h do |property|
          [
            property.name,
            send(property.name)
          ]
        end
      end
      alias cprop_inspect_map philosophal_inspect_map

      def philosophal_values
        self.class.philosophal_properties.properties_index.values
      end

      def to_json_hash
        philosophal_values.select(&:json).to_h do |property|
          [
            property.json_name,
            send(property.name)
          ]
        end
      end

      def to_json(*_args)
        to_json_hash.to_json
      end
    end
  end
end

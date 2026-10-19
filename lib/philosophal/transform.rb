# frozen_string_literal: true

module Philosophal
  class Transform
    def self.make(method, value)
      return method.call(value) if method.is_a?(Proc)

      result = value.send(method)
      self_method?(method) ? value : result
    end

    def self.self_method?(method)
      method.to_s.end_with?('!')
    end
  end
end

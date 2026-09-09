# frozen_string_literal: true

module Philosophal
  class Transform
    def self.make(method, value)
      case method
      when Proc
        method.call(value)
      else
        if self_method?(method)
          value.send(method)
          value
        else
          value.send(method)
        end
      end
    end

    def self.self_method?(method)
      method.to_s.end_with?('!')
    end
  end
end

# frozen_string_literal: true

module Philosophal
  class Transform
    def self.make(method, value)
      case method
      when Proc
        method.call(value)
      else
        value.send(method)
      end
    end
  end
end

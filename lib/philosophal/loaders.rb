# frozen_string_literal: true

module Philosophal
  module Loaders
    autoload :JSONLoader, 'philosophal/loaders/json_loader'
    autoload :LoadError, 'philosophal/loaders/errors'
  end
end
